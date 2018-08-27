module PageObjects
  module Images
    class NewPage < PageObjects::Document
      path :new_image
      path :images # failed create

      form_for :image do
        element :link
        element :tag_list
      end

      def create_image!(link: nil, tags: nil)
        self.link.set(link) if link.present?
        tag_list.set(tags) if tags.present?
        node.click_button('Create Image')
        window.change_to(ShowPage, self.class)
      end
    end
  end
end
