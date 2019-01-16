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

  describe "stmm" do
    let(:query_string) do
      <<QUERYSTRING
{
  movie(movieName: "stmm")
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

    let(:girls) { %w[
      cure_black
      cure_white
      shiny_luminous
      cure_bloom
      cure_egret
      cure_dream
      cure_rouge
      cure_lemonade
      cure_mint
      cure_aqua
      milky_rose
      cure_peach
      cure_berry
      cure_pine
      cure_passion
      cure_blossom
      cure_marine
      cure_sunshine
      cure_moonlight
      cure_melody
      cure_rhythm
      cure_beat
      cure_muse
      cure_happy
      cure_sunny
      cure_peace
      cure_march
      cure_beauty
      cure_heart
      cure_diamond
      cure_rosetta
      cure_sword
      cure_ace
      cure_lovely
      cure_princess
      cure_honey
      cure_fortune
      cure_flora
      cure_mermaid
      cure_twinkle
      cure_scarlet
      cure_miracle
      cure_magical
      cure_echo
      ] }

    context "has name and it" do
      it { expect(result["data"]["movie"]["name"]).to eq "stmm" }
    end

    context "has title and it" do
      it { expect(result["data"]["movie"]["title"]).to eq "映画 プリキュアオールスターズ みんなで歌う 奇跡の魔法！" }
    end

    context "has startedDate and it" do
      it { expect(result["data"]["movie"]["startedDate"]).to eq "2016-03-19" }
    end

    context "has girls and it" do
      it { expect(result["data"]["movie"]["girls"].count).to eq 44 }
      it { expect(result["data"]["movie"]["girls"].map{|e| e["girlName"]}).to eq girls }
    end
  end
end
