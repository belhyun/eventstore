ActiveAdmin.register Group do
  
  index do
    column 'id' do |group|
      link_to group.id, admin_group_path(group)
    end
    column :title
    column :desc
    column :tag_list
  end

  form do |f|
    f.inputs "Group" do
      f.input :title
      f.input :desc
      f.input :tag_list
    end
    f.buttons
  end
end
