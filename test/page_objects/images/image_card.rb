module PageObjects
  module Images
    class ImageCard < AePageObjects::Element
      element :image, locator: [:css, 'a .card__img']

      collection :tag_elements, locator: '.card-body', item_locator: '.tag'

      def link
        image.node[:src]
      end

      def tags
        tag_elements.map(&:text)
      end

      def click_tag!(tag_name)
        node.click_on(tag_name)
        window.change_to(IndexPage)
      end
    end
  end
end
