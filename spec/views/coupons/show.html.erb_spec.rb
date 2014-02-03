require 'spec_helper'

describe "coupons/show" do
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

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
