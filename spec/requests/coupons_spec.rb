require 'spec_helper'

describe "Coupons" do
  describe "GET /coupons" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get coupons_path
      expect(response.status).to be(200)
    end
  end
end
