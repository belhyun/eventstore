require 'spec_helper'

describe "coupons/edit" do
  before(:each) do
    @coupon = assign(:coupon, stub_model(Coupon,
      :link => "MyText",
      :gift => "MyText",
      :gift_type => "MyText",
      :description => "MyText",
      :hits => "",
      :is_premium => ""
    ))
  end

  it "renders the edit coupon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", coupon_path(@coupon), "post" do
      assert_select "textarea#coupon_link[name=?]", "coupon[link]"
      assert_select "textarea#coupon_gift[name=?]", "coupon[gift]"
      assert_select "textarea#coupon_gift_type[name=?]", "coupon[gift_type]"
      assert_select "textarea#coupon_description[name=?]", "coupon[description]"
      assert_select "input#coupon_hits[name=?]", "coupon[hits]"
      assert_select "input#coupon_is_premium[name=?]", "coupon[is_premium]"
    end
  end
end
