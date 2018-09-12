module PageObjects
  module Images
    class ShowPage < PageObjects::Document
      path :image

      collection :tag_elements, locator: '.tag-list', item_locator: 'li'
      element :modal, locator: '#shareModal'

      form_for :share_email do
        element :address
        element :message
      end

      def share_image(address: nil, message: nil)
        self.address.set(address) if address.present?
        self.message.set(message) if message.present?
        node.click_button('Send Email')
        window.change_to(self.class)
      end

      def image_url
        node.find('img')[:src]
      end

      def tags
        tag_elements.map(&:text)
      end

      def edit!
        node.click_on('Edit')
        window.change_to(EditPage)
      end

      def pop_share_modal
        node.click_on('Share Image')
      end

      def delete
        node.click_on('Delete')
        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!
        delete(&:accept)

        window.change_to(IndexPage)
      end

      def go_back_to_index!
        node.click_on('Home')
        window.change_to(IndexPage)
      end
    end
  end
end
