module PageObjects
  module Images
    class EditPage < PageObjects::Document
      path :edit_image
      path :image # failed update

      form_for :image do
        element :tag_list
      end

      # NOTE: split a valid and invalid handler for update since the change_to was not returning the
      # expected Page Object (Show when successful and Edit when failed)
      def update_image_valid!(tags: nil)
        tag_list.set(tags) if tags.present?
        node.click_button('Update Image')
        window.change_to(ShowPage)
      end

      def update_image_invalid!(tags: nil)
        tag_list.set(tags) if tags.present?
        node.click_button('Update Image')
        window.change_to(self.class)
      end
    end
  end
end
