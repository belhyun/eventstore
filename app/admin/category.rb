ActiveAdmin.register Category do
  index do
    column 'id' do |category|
      link_to category.id, admin_category_path(category)
    end
    column :title
    column :description
  end
end
