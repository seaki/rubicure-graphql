require 'rails_helper'

RSpec.describe Types::QueryType do
  let(:context) { {} }
  let(:variables) { {} }

  # Call `result` to execute the query
  let(:result) {
    res = RubicureGraphqlSchema.execute(
      query_string,
      context: context,
      variables: variables
    )
    # Print any errors
    if res["errors"]
      pp res
    end
    res
  }

  describe "query" do
    let(:query_string) do
      <<QUERYSTRING
{
  allMovies
  {
    name
  }
  allSeries
  {
    seriesName
  }
  colors
  {
    color
  }
  precureAllStars(series: "ns3")
  {
    girlName
  }
  precureDreamStars
  {
    girlName
  }
  precureSuperStars
  {
    girlName
  }
  precureMiracleLeap
  {
    girlName
  }
  precureAllGirls
  {
    girlName
  }
  precureAll
  {
    girlName
  }
}
QUERYSTRING
    end

    context "allMovies" do
      it { expect(result["data"]["allMovies"].count).to eq Rubicure::Movie.uniq_names.count }
    end

    context "allSeries" do
      it { expect(result["data"]["allSeries"].count).to eq Precure.count }
    end

    context "colors" do
      it { expect(result["data"]["colors"].count).to eq Rubicure::Girl.colors.count }
    end

    context "precureAllStars(series: \"ns3\")" do
      it { expect(result["data"]["precureAllStars"].count).to eq Precure.all_stars(:ns3).count }
    end

    context "precureDreamStars" do
      it { expect(result["data"]["precureDreamStars"].count).to eq Precure.dream_stars.count }
    end

    context "precureSuperStars" do
      it { expect(result["data"]["precureSuperStars"].count).to eq Precure.super_stars.count }
    end

    context "precureMiracleLeap" do
      it { expect(result["data"]["precureMiracleLeap"].count).to eq Precure.miracle_leap.count }
    end

    context "precureAllGirls" do
      it { expect(result["data"]["precureAllGirls"].count).to eq Precure.all_girls.count }
    end

    context "precureAll" do
      it { expect(result["data"]["precureAll"]).to eq result["data"]["precureAllGirls"] }
    end
  end

  describe "precureAllStars without argument" do
    let(:query_string) do
      <<QUERYSTRING
{
  precureAllStars
  {
    girlName
  }
}
QUERYSTRING
    end

    context "precureAllStars" do
      it { expect(result["data"]["precureAllStars"].count).to eq Precure.all_stars.count }
    end
  end

  describe "current series" do
    let(:query_string) do
      <<QUERYSTRING
{
  now
  {
    seriesName
  }
  current
  {
    seriesName
  }
}
QUERYSTRING
    end

    context "now at 2020-01-26" do
      around do |e|
        Timecop.freeze('2020-01-26') { e.run }
      end
      it "returns current series" do
        expect(result["data"]["now"]["seriesName"]).to eq Precure.now.series_name
      end
    end

    context "current at 2020-01-26" do
      around do |e|
        Timecop.freeze('2020-01-26') { e.run }
      end
      it "returns current series" do
        expect(result["data"]["current"]["seriesName"]).to eq Precure.now.series_name
      end
    end

    context "at 2020-02-01" do
      around do |e|
        Timecop.freeze('2020-02-01') { e.run }
      end
      it "returns error" do
        res = RubicureGraphqlSchema.execute(query_string).to_h

        expect(res["data"]).to be_nil
        expect(res["errors"].map { |e| e["message"] }.uniq).to eq ["Not on air precure!"]
      end
    end
  end

  describe "series(seriesName: now) when no series is on air" do
    around do |e|
      Timecop.freeze('2020-02-01') { e.run }
    end

    it "returns error" do
      res = RubicureGraphqlSchema.execute('{ series(seriesName: "now") { seriesName } }').to_h

      expect(res).to match(
        "data" => nil,
        "errors" => [a_hash_including("message" => "Not on air precure!", "path" => ["series"])]
      )
    end
  end

  describe "names that do not exist" do
    {
      '{ member(memberName: "unknown") { memberName } }' => ["member", "unknown member: unknown"],
      '{ member(memberName: "") { memberName } }' => ["member", "unknown member: "],
      '{ member(memberName: "class") { memberName } }' => ["member", "unknown member: class"],
      '{ girl(girlName: "unknown") { girlName } }' => ["girl", "unknown girl: unknown"],
      '{ movie(movieName: "unknown") { name } }' => ["movie", "unknown movie: unknown"],
      '{ movie(movieName: "") { name } }' => ["movie", "unknown movie: "],
      '{ precureAllStars(series: "unknown") { memberName } }' => ["precureAllStars", "unknown movie: unknown"],
      '{ color(color: "unknown") { color } }' => ["color", "unknown color: unknown"],
      '{ color(color: "") { color } }' => ["color", "unknown color: "],
    }.each do |query, (field, message)|
      context query do
        it "returns an error" do
          res = RubicureGraphqlSchema.execute(query).to_h

          expect(res).to match(
            "data" => nil,
            "errors" => [a_hash_including("message" => message, "path" => [field])]
          )
        end
      end
    end

    context "precureAllStars with an empty series" do
      it "is the same as without the argument" do
        res = RubicureGraphqlSchema.execute('{ a: precureAllStars(series: "") { memberName } b: precureAllStars { memberName } }').to_h

        expect(res["errors"]).to be_nil
        expect(res["data"]["a"]).to eq res["data"]["b"]
      end
    end
  end

  describe "series(seriesName: now)" do
    let(:query_string) do
      <<QUERYSTRING
{
  series(seriesName: "now")
  {
    seriesName
  }
}
QUERYSTRING
    end

    around do |e|
      Timecop.freeze('2020-01-26') { e.run }
    end
    it "returns current series" do
      expect(result["data"]["series"]["seriesName"]).to eq Precure.now.series_name
    end
  end

  describe "series(seriesName: current)" do
    let(:query_string) do
      <<QUERYSTRING
{
  series(seriesName: "current")
  {
    seriesName
  }
}
QUERYSTRING
    end

    around do |e|
      Timecop.freeze('2020-01-26') { e.run }
    end
    it "returns current series" do
      expect(result["data"]["series"]["seriesName"]).to eq Precure.now.series_name
    end
  end

  describe "series(seriesName:) with a name that is not a series" do
    let(:result) { RubicureGraphqlSchema.execute(query_string) }

    ["unknown", "all_stars", "class", "object_id", "send", ""].each do |name|
      context "seriesName: #{name.inspect}" do
        let(:query_string) { %({ series(seriesName: "#{name}") { seriesName } }) }

        it "returns an error" do
          expect(result.to_h).to match(
            "data" => nil,
            "errors" => [a_hash_including("message" => "unknown series: #{name}", "path" => ["series"])]
          )
        end
      end
    end

    context "when the name is a method of Precure" do
      let(:query_string) { %({ series(seriesName: "all_stars") { seriesName } }) }

      it "does not call the method" do
        expect(Rubicure::Core.instance).not_to receive(:all_stars)
        result
      end
    end
  end

  describe "version" do
    let(:query_string) do
      <<QUERYSTRING
{
  version
}
QUERYSTRING
    end

    context "version" do
      it { expect(result["data"]["version"]).to eq Rails.configuration.x.version }
    end
  end
end
