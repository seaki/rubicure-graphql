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

    context "precureAllGirls" do
      it { expect(result["data"]["precureAllGirls"].count).to eq Precure.all_girls.count }
    end

    context "precureAll" do
      it { expect(result["data"]["precureAll"]).to eq result["data"]["precureAllGirls"] }
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
