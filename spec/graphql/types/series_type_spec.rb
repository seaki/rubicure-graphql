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
  }
}
QUERYSTRING
    end

    let(:girls) { %w[cure_miracle cure_magical cure_felice] }

    context "has seriesName and it" do
      it { expect(result["data"]["series"]["seriesName"]).to eq "maho_girls" }
    end

    context "has title and it" do
      it { expect(result["data"]["series"]["title"]).to eq "魔法つかいプリキュア！" }
    end

    context "has startedDate and it" do
      it { expect(result["data"]["series"]["startedDate"]).to eq "2016-02-07" }
    end

    context "has endedDate and it" do
      it { expect(result["data"]["series"]["endedDate"]).to eq "2017-01-29" }
    end

    context "has girlsCount and it" do
      it { expect(result["data"]["series"]["girlsCount"]).to eq 3 }
    end

    context "has girls and it" do
      it { expect(result["data"]["series"]["girls"].map{|e| e["girlName"]}).to eq girls }
    end
  end
end
