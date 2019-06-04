require 'rails_helper'

RSpec.describe Types::GirlType do
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

  # let(:transform_styles) { %w[diamond ruby sapphire topaz] }

  describe "cureMiracle" do
    let(:query_string) do
      <<QUERYSTRING
query {
  cureMiracle
  {
    girlName
    humanName
    humanFullName
    humanTurnoverName
    precureName
    castName
    color
    createdDate
    birthday
    transformMessages
    {
      transformStyle
      transformMessage
    }
    extraNames
    attackMessages
    {
      transformStyle
      attackMessages
    }
    transformCalls
    fullName
    transformStyles
    pikarinJanken
    heisei
    reiwa
  }
}
QUERYSTRING
    end

    context "has girlName and it" do
      it { expect(result["data"]["cureMiracle"]["girlName"]).to eq "cure_miracle" }
    end

    context "has humanName and it" do
      it { expect(result["data"]["cureMiracle"]["humanName"]).to eq Cure.miracle.human_name }
    end

    context "has humanFullName and it" do
      it { expect(result["data"]["cureMiracle"]["humanFullName"]).to be_nil }
    end

    context "has humanTurnoverName and it" do
      it do
        expect(result["data"]["cureMiracle"]["humanTurnoverName"]).to \
          eq result["data"]["cureMiracle"]["humanName"]
      end
    end

    context "has precureName and it" do
      it { expect(result["data"]["cureMiracle"]["precureName"]).to eq Cure.miracle.precure_name }
    end

    context "has castName and it" do
      it { expect(result["data"]["cureMiracle"]["castName"]).to eq Cure.miracle.cast_name }
    end

    context "has color and it" do
      it { expect(result["data"]["cureMiracle"]["color"]).to eq Cure.miracle.color }
    end

    context "has createdDate and it" do
      it { expect(result["data"]["cureMiracle"]["createdDate"]).to eq "#{Cure.miracle.created_date}" }
    end

    context "has birthday and it" do
      it { expect(result["data"]["cureMiracle"]["birthday"]).to eq "#{Cure.miracle.birthday}" }
    end

    context "has transformStyles and it" do
      let(:r_transform_styles) { result["data"]["cureMiracle"]["transformStyles"] }
      it { expect(r_transform_styles.count).to eq Cure.miracle.transform_styles.count }
      it { expect(r_transform_styles).to eq Cure.miracle.transform_styles.map{|s| s.first.to_s} }
    end

    context "has transformMessages and it" do
      let(:r_transform_messages) { result["data"]["cureMiracle"]["transformMessages"] }
      it { expect(r_transform_messages.count).to eq 4 }
      it { expect(r_transform_messages.map{|e| e["transformStyle"]}).to eq Cure.miracle.transform_styles.map{|s| s.first.to_s} }
      it { expect(r_transform_messages.map{|e| e["transformMessage"]}).to all( be_truthy ) }
      it do
        expect(r_transform_messages.map{|e| e["transformStyle"]}).to \
          eq result["data"]["cureMiracle"]["transformStyles"]
      end
    end

    context "has extraNames and it" do
      it { expect(result["data"]["cureMiracle"]["extraNames"]).to be_nil }
    end

    context "has attackMessages and it" do
      let(:r_attack_messages) { result["data"]["cureMiracle"]["attackMessages"] }
      it { expect(r_attack_messages.count).to eq 4 }
      it { expect(r_attack_messages.map{|e| e["transformStyle"]}).to eq Cure.miracle.transform_styles.map{|s| s.first.to_s} }
      it { expect(r_attack_messages.map{|e| e["attackMessages"]}).to all( be_a(Array) ) }
      it do
        expect(r_attack_messages.map{|e| e["transformStyle"]}).to \
          eq result["data"]["cureMiracle"]["transformStyles"]
      end
    end

    context "has transformCalls and it" do
      it { expect(result["data"]["cureMiracle"]["transformCalls"]).to eq Cure.miracle.transform_calls }
    end

    context "has fullName and it" do
      it do
        expect(result["data"]["cureMiracle"]["fullName"]).to \
          eq result["data"]["cureMiracle"]["humanName"]
      end
    end

    context "has pikarinJanken and it" do
      it { expect(result["data"]["cureMiracle"]["pikarinJanken"]).to be_nil }
    end

    context "has heisei and it" do
      it { expect(result["data"]["cureMiracle"]["heisei"]).to eq Cure.miracle.heisei? }
    end

    context "has reiwa and it" do
      it { expect(result["data"]["cureMiracle"]["reiwa"]).to eq Cure.miracle.reiwa? }
    end
  end

  describe "curePeace" do
    let(:query_string) do
      <<QUERYSTRING
query {
  curePeace
  {
    pikarinJanken
  }
}
QUERYSTRING
    end

    context "has pikarinJanken and it" do
      it { expect(result["data"]["curePeace"]["pikarinJanken"]).to include("ピカピカピカリン") }
    end
  end

  describe "curePassion, cureBeat, cureScarlet" do
    let(:query_string) do
      <<QUERYSTRING
query {
  curePassion
  {
    humanTurnoverName
  }
  cureBeat
  {
    humanTurnoverName
  }
  cureScarlet
  {
    humanTurnoverName
  }
}
QUERYSTRING
    end

    context "has humanTurnoverName and it" do
      it { expect(result["data"]["curePassion"]["humanTurnoverName"]).to eq (!Cure.passion).human_name }
      it { expect(result["data"]["cureBeat"]["humanTurnoverName"]).to eq (!Cure.beat).human_name }
      it { expect(result["data"]["cureScarlet"]["humanTurnoverName"]).to eq (!Cure.scarlet).human_name }
    end
  end

  describe "curePrincess, cureScarlet" do
    let(:query_string) do
      <<QUERYSTRING
query {
  curePrincess
  {
    humanFullName
  }
  cureScarlet
  {
    humanFullName
  }
}
QUERYSTRING
    end

    context "has humanFullName and it" do
      it { expect(result["data"]["curePrincess"]["humanFullName"]).to eq Cure.princess.human_full_name }
      it { expect(result["data"]["cureScarlet"]["humanFullName"]).to eq Cure.scarlet.human_full_name }
    end
  end

  describe "transformStyles" do
    let(:query_string) do
      <<QUERYSTRING
query {
  cureMiracle
  {
    transformStyles
  }
  cureMagical
  {
    transformStyles
  }
  cureFelice
  {
    transformStyles
  }
  cureBlack
  {
    transformStyles
  }
}
QUERYSTRING
    end

    context "are defined when Maho girls Precure" do
      it { expect(result["data"]["cureMiracle"]["transformStyles"]).to eq Cure.miracle.transform_styles.map{|s| s.first.to_s} }
      it { expect(result["data"]["cureMagical"]["transformStyles"]).to eq Cure.magical.transform_styles.map{|s| s.first.to_s} }
      it { expect(result["data"]["cureFelice"]["transformStyles"]).to eq Cure.felice.transform_styles.map{|s| s.first.to_s} }
    end
    context "are not defined expect Maho girls Precure" do
      it { expect(result["data"]["cureBlack"]["transformStyles"]).to be_nil }
    end
  end

  describe "transformMessages, attackMessages" do
    let(:query_string) do
      <<QUERYSTRING
query {
  cureBlack
  {
    transformMessages { transformStyle }
    attackMessages { transformStyle }
  }
}
QUERYSTRING
    end

    context "of transformStyle is default" do
      it { expect(result["data"]["cureBlack"]["transformMessages"].map{|e| e["transformStyle"]}).to eq %w[default] }
      it { expect(result["data"]["cureBlack"]["attackMessages"].map{|e| e["transformStyle"]}).to eq %w[default] }
    end
  end

  describe "girl(girlName: \"miracle\") between cureMiracle" do
    let(:query_string) do
      <<QUERYSTRING
query {
  girl(girlName: "miracle")
  {
    girlName
    humanName
    humanFullName
    humanTurnoverName
    precureName
    castName
    color
    createdDate
    birthday
    transformMessages
    {
      transformStyle
      transformMessage
    }
    extraNames
    attackMessages
    {
      transformStyle
      attackMessages
    }
    transformCalls
    fullName
    transformStyles
    pikarinJanken
  }
  cureMiracle
  {
    girlName
    humanName
    humanFullName
    humanTurnoverName
    precureName
    castName
    color
    createdDate
    birthday
    transformMessages
    {
      transformStyle
      transformMessage
    }
    extraNames
    attackMessages
    {
      transformStyle
      attackMessages
    }
    transformCalls
    fullName
    transformStyles
    pikarinJanken
  }
}
QUERYSTRING
    end

    context "are" do
      it { expect(result["data"]["girl"]).to eq result["data"]["cureMiracle"] }
    end
  end
end
