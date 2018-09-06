module PageObjects
  module Images
    class SharePage < PageObjects::Document
      path :share

      form_for :share_email do
        element :address
        element :message
      end

      def share_image!(address: nil, message: nil)
        self.address.set(address) if address.present?
        self.message.set(message) if message.present?
        node.click_button('Send Email')
        window.change_to(IndexPage, self.class)
      end
    end
  end
end
