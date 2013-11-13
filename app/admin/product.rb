ActiveAdmin.register Product do
  form do |f|
    f.inputs "Product" do
      f.input :publisher
      f.input :title
      f.input :description
      f.input :link
      f.input :gift
      f.input :end_date
      f.input :image
      f.input :score
    end
    f.buttons
  end
end
