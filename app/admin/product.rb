ActiveAdmin.register Product do
  show do
    attributes_table do
      row :publisher
      row :title
      row :description
      row :end_date
      row :join_method
      row :link
      row :score do
        $redis.zscore(Rails.application.config.rank_key, product.id)
      end
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
      f.input :score, :required => true, :input_html => { :value => $redis.zscore(Rails.application.config.rank_key, product.id)}
      f.input :categories, :as => :check_boxes, :collection => Category.all
      f.input :groups, :as => :check_boxes, :collection => Group.all
    end
    f.buttons
  end
end
