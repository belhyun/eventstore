require 'spec_helper'

describe CategoriesController do
  it "responds successfully with an HTTP 200 status code" do
    get :show, {:id => 11}
    expect(response).to render_template('show')
  end
end
