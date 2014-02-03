require 'spec_helper'

describe "coupons/new" do
  before(:each) do
    assign(:coupon, stub_model(Coupon,
      :link => "MyText",
      :gift => "MyText",
      :gift_type => "MyText",
      :description => "MyText",
      :hits => "",
      :is_premium => ""
    ).as_new_record)
  end

  it "renders new coupon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", coupons_path, "post" do
      assert_select "textarea#coupon_link[name=?]", "coupon[link]"
      assert_select "textarea#coupon_gift[name=?]", "coupon[gift]"
      assert_select "textarea#coupon_gift_type[name=?]", "coupon[gift_type]"
      assert_select "textarea#coupon_description[name=?]", "coupon[description]"
      assert_select "input#coupon_hits[name=?]", "coupon[hits]"
      assert_select "input#coupon_is_premium[name=?]", "coupon[is_premium]"
    end
  end
end
