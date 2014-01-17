require 'spec_helper'

describe ProductsController do
  describe "GET #story" do
    it "responds successfully with an HTTP 200 status code" do
      get :story
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end
