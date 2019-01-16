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
      it { expect(result["data"]["allMovies"].count).to eq 11 }
    end

    context "allSeries" do
      it { expect(result["data"]["allSeries"].count).to eq 15 }
    end

    context "colors" do
      it { expect(result["data"]["colors"].count).to eq 9 }
    end

    context "precureAllStars" do
      it { expect(result["data"]["precureAllStars"].count).to eq 37 }
    end

    context "precureDreamStars" do
      it { expect(result["data"]["precureDreamStars"].count).to eq 12 }
    end

    context "precureSuperStars" do
      it { expect(result["data"]["precureSuperStars"].count).to eq 12 }
    end

    context "precureAllGirls" do
      it { expect(result["data"]["precureAllGirls"].count).to eq 56 }
    end

    context "precureAll" do
      it { expect(result["data"]["precureAll"]).to eq result["data"]["precureAllGirls"] }
    end
  end
end
