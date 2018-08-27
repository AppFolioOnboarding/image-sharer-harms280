module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '.card-columns', item_locator: '.card', contains: ImageCard do
        def view!
          node.click

          window.change_to(ShowPage)
        end
      end

      def add_new_image!
        node.click_on('Add Image')
        window.change_to(NewPage)
      end

      def showing_image?(link:, tags: nil)
        images.any? do |image|
          result = image.link == link
          # tags.present? ? (result && image.tags == tags): result
        end
      end

      def clear_tag_filter!
        # TODO
      end
    end
  end
end
