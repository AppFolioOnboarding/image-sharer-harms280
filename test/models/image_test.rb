require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def test_image__valid
    image = Image.new(link: 'https://carepharmaceuticals.com.au/wp-content/uploads/sites/19/2018/02/placeholder-600x400.png')

    assert_predicate image, :valid?
  end

  def test_image__invalid_if_link_is_blank
    image = Image.new(link: '')

    assert_not_predicate image, :valid?
    assert_equal "can't be blank", image.errors.messages[:link].first
  end
end
