ActiveAdmin.register Coupon do
  show do
    attributes_table do
      row :publisher
      row :title
      row :description
      row :end_date
      row :link
    end
  end

  form do |f|
    f.inputs "Product" do
      f.input :publisher
      f.input :title
      f.input :description
      f.input :link
      f.input :gift
      f.input :end_date
      f.input :image
      f.input :is_premium
    end
    f.buttons
  end
end
