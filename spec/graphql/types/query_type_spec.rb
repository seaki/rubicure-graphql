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
        expect { result }.to raise_error(Rubicure::NotOnAirError)
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
