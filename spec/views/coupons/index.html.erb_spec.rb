require 'spec_helper'

describe "coupons/index" do
  before(:each) do
    assign(:coupons, [
      stub_model(Coupon,
        :link => "MyText",
        :gift => "MyText",
        :gift_type => "MyText",
        :description => "MyText",
        :hits => "",
        :is_premium => ""
      ),
      stub_model(Coupon,
        :link => "MyText",
        :gift => "MyText",
        :gift_type => "MyText",
        :description => "MyText",
        :hits => "",
        :is_premium => ""
      )
    ])
  end

  it "renders a list of coupons" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
