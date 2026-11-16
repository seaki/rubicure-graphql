require 'rails_helper'

RSpec.describe "GraphQL Endpoint", type: :request do
  let(:json) { JSON.parse(response.body) }
  let(:version) { { "data" => { "version" => Rails.configuration.x.version } } }
  let(:member_query) { "query($name: String!) { member(memberName: $name) { precureName } }" }
  let(:wing) { { "data" => { "member" => { "precureName" => Cure.wing.precure_name } } } }

  describe "POST /graphql" do
    context "with a JSON body" do
      it "returns the result as JSON" do
        post "/graphql", params: { query: "{ version }" }, as: :json

        expect(response).to have_http_status(200)
        expect(response.media_type).to eq "application/json"
        expect(json).to eq version
      end

      it "accepts variables as an object" do
        post "/graphql", params: { query: member_query, variables: { name: "wing" } }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq wing
      end

      it "accepts variables as a JSON string" do
        post "/graphql", params: { query: member_query, variables: '{"name":"wing"}' }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq wing
      end

      it "accepts an empty string as variables" do
        post "/graphql", params: { query: "{ version }", variables: "" }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq version
      end

      it "accepts null as variables" do
        post "/graphql", params: { query: "{ version }", variables: nil }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq version
      end

      it "accepts the string null as variables" do
        post "/graphql", params: { query: "{ version }", variables: "null" }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq version
      end

      it "runs the operation named by operationName" do
        query = "query A { version } query B { colors { color } }"
        post "/graphql", params: { query: query, operationName: "B" }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq("data" => { "colors" => Rubicure::Girl.colors.map { |c| { "color" => c.to_s } } })
      end
    end

    context "with a form-encoded body" do
      it "returns the result as JSON" do
        post "/graphql", params: { query: "{ version }" }

        expect(response).to have_http_status(200)
        expect(response.media_type).to eq "application/json"
        expect(json).to eq version
      end

      it "accepts variables as a JSON string" do
        post "/graphql", params: { query: member_query, variables: '{"name":"wing"}' }

        expect(response).to have_http_status(200)
        expect(json).to eq wing
      end
    end

    # The test environment turns the protection off; production does not.
    context "when the forgery protection is enabled" do
      around do |example|
        original = ActionController::Base.allow_forgery_protection
        ActionController::Base.allow_forgery_protection = true
        example.run
      ensure
        ActionController::Base.allow_forgery_protection = original
      end

      it "accepts a JSON body without an authenticity token" do
        post "/graphql", params: { query: "{ version }" }, as: :json

        expect(response).to have_http_status(200)
        expect(json).to eq version
      end

      it "accepts a form-encoded body without an authenticity token" do
        post "/graphql", params: { query: "{ version }" }

        expect(response).to have_http_status(200)
        expect(json).to eq version
      end
    end

    context "with a query that cannot be executed" do
      it "reports a syntax error in errors" do
        post "/graphql", params: { query: "{" }, as: :json

        expect(response).to have_http_status(200)
        expect(json["errors"]).not_to be_empty
        expect(json["data"]).to be_nil
      end

      it "reports a missing query in errors" do
        post "/graphql", params: {}, as: :json

        expect(response).to have_http_status(200)
        expect(json["errors"]).not_to be_empty
        expect(json["data"]).to be_nil
      end

      it "reports an unknown field in errors" do
        post "/graphql", params: { query: "{ unknownField }" }, as: :json

        expect(response).to have_http_status(200)
        expect(json["errors"]).not_to be_empty
        expect(json["data"]).to be_nil
      end

      it "reports a missing variable in errors" do
        post "/graphql", params: { query: member_query }, as: :json

        expect(response).to have_http_status(200)
        expect(json["errors"]).not_to be_empty
        expect(json["data"]).to be_nil
      end

      it "reports a name that does not exist in errors" do
        post "/graphql", params: { query: member_query, variables: { name: "unknown" } }, as: :json

        expect(response).to have_http_status(200)
        expect(json["errors"].map { |e| e["message"] }).to eq ["unknown member: unknown"]
        expect(json["data"]).to be_nil
      end
    end

    context "with variables that are not an object" do
      it "rejects a string that is not JSON" do
        post "/graphql", params: { query: "{ version }", variables: "{" }, as: :json

        expect(response).to have_http_status(400)
        expect(json).to eq("errors" => [{ "message" => "variables is not valid JSON" }])
      end

      it "rejects a JSON string that is not an object" do
        post "/graphql", params: { query: "{ version }", variables: "[1]" }, as: :json

        expect(response).to have_http_status(400)
        expect(json).to eq("errors" => [{ "message" => "variables must be an object" }])
      end

      it "rejects a number" do
        post "/graphql", params: { query: "{ version }", variables: 1 }, as: :json

        expect(response).to have_http_status(400)
        expect(json).to eq("errors" => [{ "message" => "variables must be an object" }])
      end

      it "rejects an array" do
        post "/graphql", params: { query: "{ version }", variables: [1] }, as: :json

        expect(response).to have_http_status(400)
        expect(json).to eq("errors" => [{ "message" => "variables must be an object" }])
      end

      it "rejects a form-encoded string that is not JSON" do
        post "/graphql", params: { query: "{ version }", variables: "{" }

        expect(response).to have_http_status(400)
        expect(json).to eq("errors" => [{ "message" => "variables is not valid JSON" }])
      end
    end
  end

  describe "GET /graphql" do
    it "is not routed" do
      get "/graphql", params: { query: "{ version }" }

      expect(response).to have_http_status(404)
    end
  end
end
