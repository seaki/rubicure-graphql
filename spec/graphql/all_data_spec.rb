require 'rails_helper'

# Queries everything the rubicure gem knows, with every field selected. The types
# are built on the data of the gem, so an update of the gem that they cannot
# handle (a new series, member or movie, or a changed method) fails here.
RSpec.describe RubicureGraphqlSchema do
  let(:types) do
    {
      "Member" => Types::MemberType,
      "Series" => Types::SeriesType,
      "Movie" => Types::MovieType,
      "Color" => Types::ColorType,
    }
  end

  let(:selections) do
    {
      "Member" => "girlName memberName humanName humanFullName humanTurnoverName precureName castName color " \
                  "createdDate birthday transformMessage transformMessages { transformStyle transformMessage } " \
                  "extraNames attackMessages { transformStyle attackMessages } transformCalls fullName " \
                  "transformStyles pikarinJanken heisei reiwa randomTransformWords",
      "Series" => "seriesName title startedDate endedDate girls { girlName } girlsCount " \
                  "members { memberName } membersCount heisei reiwa",
      "Movie" => "title startedDate name girls { girlName } members { memberName }",
      "Color" => "color girls { girlName } members { memberName }",
    }
  end

  # @return [Hash] the queries that did not return data, with the reason
  def failures_of(queries)
    queries.each_with_object({}) do |(label, query), failures|
      begin
        res = RubicureGraphqlSchema.execute(query).to_h
        failures[label] = res["errors"] if res["errors"] || res["data"].nil? || res["data"].value?(nil)
      rescue StandardError => e
        failures[label] = "#{e.class}: #{e.message}"
      end
    end
  end

  it "selects every field of the types in this spec" do
    types.each do |name, type|
      document = GraphQL.parse("{ root { #{selections.fetch(name)} } }")
      selected = document.definitions.first.selections.first.selections.map(&:name)

      expect(selected).to match_array(type.fields.keys), "the selection of #{name} is out of date"
    end
  end

  describe "root fields" do
    # now and current depend on the date and are covered by query_type_spec.rb
    let(:root_fields) do
      Types::QueryType.fields.reject do |name, field|
        %w[now current].include?(name) || field.arguments.values.any? { |argument| argument.type.non_null? }
      end
    end

    it "covers a field of every member besides the fixed ones" do
      expect(root_fields.size).to be > Precure.all_girls.size
    end

    it "resolves every field that needs no argument" do
      queries = root_fields.to_h do |name, field|
        selection = selections[field.type.unwrap.graphql_name]
        [name, selection ? "{ #{name} { #{selection} } }" : "{ #{name} }"]
      end

      expect(failures_of(queries)).to eq({})
    end

    context "while a series is on air" do
      around do |e|
        Timecop.freeze('2020-01-26') { e.run }
      end

      it "resolves now and current" do
        queries = %w[now current].to_h { |name| [name, "{ #{name} { #{selections['Series']} } }"] }

        expect(failures_of(queries)).to eq({})
      end
    end
  end

  describe "every name the gem knows" do
    it "resolves every member" do
      queries = Rubicure::Girl.names.to_h do |name|
        [name, %({ member(memberName: "#{name}") { #{selections['Member']} } girl(girlName: "#{name}") { girlName } })]
      end

      expect(queries).not_to be_empty
      expect(failures_of(queries)).to eq({})
    end

    it "resolves every series" do
      queries = Rubicure::Series.names.to_h do |name|
        [name, %({ series(seriesName: "#{name}") { #{selections['Series']} } })]
      end

      expect(queries).not_to be_empty
      expect(failures_of(queries)).to eq({})
    end

    it "resolves every movie" do
      queries = Rubicure::Movie.names.to_h do |name|
        [name, %({ movie(movieName: "#{name}") { #{selections['Movie']} } precureAllStars(series: "#{name}") { memberName } })]
      end

      expect(queries).not_to be_empty
      expect(failures_of(queries)).to eq({})
    end

    it "resolves every color" do
      queries = Rubicure::Girl.colors.to_h do |name|
        [name, %({ color(color: "#{name}") { #{selections['Color']} } })]
      end

      expect(queries).not_to be_empty
      expect(failures_of(queries)).to eq({})
    end
  end

  describe "schema" do
    it "answers the introspection query that GraphiQL sends" do
      res = RubicureGraphqlSchema.execute(GraphQL::Introspection::INTROSPECTION_QUERY).to_h

      expect(res["errors"]).to be_nil
      expect(res["data"]["__schema"]["queryType"]).to eq("name" => "Query")
    end

    it "can be printed as a schema definition" do
      expect(RubicureGraphqlSchema.to_definition).to include("type Query {", "type Member {", "type Series {")
    end
  end
end
