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

  describe "rainbow" do
    let(:query_string) do
      <<QUERYSTRING
{
  color(color: "rainbow")
  {
    color
    girls {
      girlName
    }
  }
}
QUERYSTRING
    end

    context "has color and it" do
      it { expect(result["data"]["color"]["color"]).to eq "rainbow" }
    end

    context "has girls and it" do
      it { expect(result["data"]["color"]["girls"].count).to eq 1 }
      it { expect(result["data"]["color"]["girls"].map{|e| e["girlName"]}).to eq %w[cure_parfait] }
    end
  end
end
