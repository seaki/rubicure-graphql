require 'rails_helper'

RSpec.describe "GraphiQLs", type: :request do
  describe "GET /graphiqls" do
    it "works! (now write some real specs)" do
      get graphiqls_path
      expect(response).to have_http_status(200)
    end
  end
end
