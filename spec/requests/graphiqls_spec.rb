require 'rails_helper'

RSpec.describe "GraphiQL Endpoint", type: :request do
  describe "GET /graphiql" do
    context "when ENABLE_GRAPHIQL is set" do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('ENABLE_GRAPHIQL').and_return('true')
        Rails.application.reload_routes!
      end

      it "works! (now write some real specs)" do
        get graphiql_rails_path
        expect(response).to have_http_status(200)
      end

      it "serves the assets bundled with graphiql-rails without an asset pipeline" do
        get graphiql_rails_path
        asset_paths = response.body.scan(%r{(?:href|src)="(/graphiql-rails/[^"]+)"}).flatten
        expect(asset_paths).not_to be_empty

        asset_paths.each do |path|
          get path
          expect(response).to have_http_status(200)
        end
      end
    end

    context "when ENABLE_GRAPHIQL is not set" do
      before do
        Rails.application.reload_routes!
      end

      it "has no mapping to the path" do
        expect{ get graphiql_rails_path }.to raise_error(NameError)
      end

      it "is expect to fail" do
        # but it will be redirected to 500
        # expect{ get '/graphiql' }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
