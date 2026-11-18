require "rails_helper"

RSpec.describe "Rails frameworks" do
  # The app keeps no data of its own, so Active Record (and a database) is not loaded.
  it "does not load Active Record" do
    expect(defined?(ActiveRecord::Base)).to be_nil
  end
end
