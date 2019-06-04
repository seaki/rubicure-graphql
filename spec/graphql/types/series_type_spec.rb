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

    context "has heisei and it" do
      it { expect(result["data"]["series"]["heisei"]).to eq Precure.maho_girls.heisei?.to_s }
    end

    context "has reiwa and it" do
      it { expect(result["data"]["series"]["reiwa"]).to eq Precure.maho_girls.reiwa?.to_s }
    end
  end
end
