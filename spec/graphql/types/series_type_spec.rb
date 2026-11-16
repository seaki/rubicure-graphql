require 'rails_helper'

RSpec.describe Types::SeriesType do
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

  describe "maho_girls" do
    let(:query_string) do
      <<QUERYSTRING
{
  series(seriesName: "maho_girls") {
    seriesName
    title
    startedDate
    endedDate
    girlsCount
    girls
    {
      girlName
    }
    membersCount
    members
    {
      memberName
    }
    heisei
    reiwa
  }
}
QUERYSTRING
    end

    context "has seriesName and it" do
      it { expect(result["data"]["series"]["seriesName"]).to eq "maho_girls" }
    end

    context "has title and it" do
      it { expect(result["data"]["series"]["title"]).to eq Precure.maho_girls.title }
    end

    context "has startedDate and it" do
      it { expect(result["data"]["series"]["startedDate"]).to eq "#{Precure.maho_girls.started_date}" }
    end

    context "has endedDate and it" do
      it { expect(result["data"]["series"]["endedDate"]).to eq "#{Precure.maho_girls.ended_date}" }
    end

    context "has girlsCount and it" do
      it { expect(result["data"]["series"]["girlsCount"]).to eq Precure.maho_girls.girls.count }
    end

    context "has girls and it" do
      it { expect(result["data"]["series"]["girls"].map{|e| e["girlName"]}).to eq Precure.maho_girls.girls.map(&:girl_name) }
    end

    context "has membersCount and it" do
      it { expect(result["data"]["series"]["membersCount"]).to eq Precure.maho_girls.members.count }
    end

    context "has members and it" do
      it { expect(result["data"]["series"]["members"].map{|e| e["memberName"]}).to eq Precure.maho_girls.members.map(&:girl_name) }
    end

    context "has heisei and it" do
      it { expect(result["data"]["series"]["heisei"]).to eq Precure.maho_girls.heisei?.to_s }
    end

    context "has reiwa and it" do
      it { expect(result["data"]["series"]["reiwa"]).to eq Precure.maho_girls.reiwa?.to_s }
    end
  end

  describe "series on air" do
    # A series that is still on air has no ended_date.
    let(:on_air_series) do
      Rubicure::Series[series_name: "on_air", title: "On air", started_date: started_date, girls: %w[cure_black]]
    end

    let(:query_string) do
      <<QUERYSTRING
{
  now {
    seriesName
    title
    startedDate
    endedDate
    girlsCount
    membersCount
    heisei
    reiwa
  }
}
QUERYSTRING
    end

    before do
      allow(Rubicure::Core.instance).to receive(:now).and_return(on_air_series)
    end

    context "started in Reiwa" do
      let(:started_date) { Date.new(2019, 5, 1) }

      it "returns every field, with null as endedDate" do
        expect(result.to_h).to eq(
          "data" => {
            "now" => {
              "seriesName" => "on_air",
              "title" => "On air",
              "startedDate" => "2019-05-01",
              "endedDate" => nil,
              "girlsCount" => 1,
              "membersCount" => 1,
              "heisei" => "false",
              "reiwa" => "true",
            },
          }
        )
      end
    end

    context "started in Heisei" do
      let(:started_date) { Date.new(2019, 4, 30) }

      it { expect(result["data"]["now"]["endedDate"]).to be_nil }
      it { expect(result["data"]["now"]["heisei"]).to eq "true" }
      it { expect(result["data"]["now"]["reiwa"]).to eq "true" }
    end
  end

  describe "every series" do
    let(:fields) do
      "seriesName title startedDate endedDate girlsCount girls { girlName } membersCount members { memberName } heisei reiwa"
    end

    it "returns every field without errors" do
      Rubicure::Series.names.each do |name|
        res = RubicureGraphqlSchema.execute(%({ series(seriesName: "#{name}") { #{fields} } }))

        expect(res["errors"]).to be_nil, "#{name}: #{res['errors'].inspect}"
        expect(res["data"]["series"]["seriesName"]).to eq Rubicure::Series.find(name).series_name
      end
    end

    it "returns every field of allSeries without errors" do
      res = RubicureGraphqlSchema.execute("{ allSeries { #{fields} } }")

      expect(res["errors"]).to be_nil
      expect(res["data"]["allSeries"].map { |s| s["seriesName"] }).to eq Precure.map(&:series_name)
    end
  end
end
