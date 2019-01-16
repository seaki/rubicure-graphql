require 'rails_helper'

RSpec.describe Types::MovieType do
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

  describe "sing_together_miracle_magic" do
    let(:query_string) do
      <<QUERYSTRING
{
  movie(movieName: "sing_together_miracle_magic")
  {
    name
    title
    startedDate
    girls
    {
      girlName
    }
  }
}
QUERYSTRING
    end

    context "has name and it" do
      it { expect(result["data"]["movie"]["name"]).to eq "stmm" }
    end

    context "has title and it" do
      it { expect(result["data"]["movie"]["title"]).to eq Rubicure::Movie.find(:stmm).title }
    end

    context "has startedDate and it" do
      it { expect(result["data"]["movie"]["startedDate"]).to eq "#{Rubicure::Movie.find(:stmm).started_date}" }
    end

    context "has girls and it" do
      it { expect(result["data"]["movie"]["girls"].count).to eq Precure.all_stars(:stmm).count }
      it { expect(result["data"]["movie"]["girls"].map{|e| e["girlName"]}).to eq Precure.all_stars(:stmm).map(&:girl_name) }
    end
  end
end
