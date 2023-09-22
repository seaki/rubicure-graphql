require 'rails_helper'

RSpec.describe Types::ColorType do
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

  let(:transform_styles) { %w[diamond ruby sapphire topaz] }

  describe "pink" do
    let(:query_string) do
      <<QUERYSTRING
{
  color(color: "pink")
  {
    color
    girls {
      girlName
    }
    members
    {
      memberName
    }
  }
}
QUERYSTRING
    end

    context "has color and it" do
      it { expect(result["data"]["color"]["color"]).to eq "pink" }
    end

    context "has girls and it" do
      it { expect(result["data"]["color"]["girls"].count).to eq Precure.all_girls.select(&:pink?).count }
      it { expect(result["data"]["color"]["girls"].map{|e| e["girlName"]}).to eq Precure.all_girls.select(&:pink?).map(&:girl_name) }
    end

    context "has members and it" do
      it { expect(result["data"]["color"]["members"].count).to eq Precure.all_members.select(&:pink?).count }
      it { expect(result["data"]["color"]["members"].map{|e| e["memberName"]}).to eq Precure.all_members.select(&:pink?).map(&:girl_name) }
    end
  end
end
