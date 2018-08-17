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

  def test_image__valid_if_link_is_valid_url
    valid_urls = %w[https://www.massinsight.org/wp-content/uploads/2016/05/placeholder-4-500x300.png
                    https://www.massinsight.org http://www.massinsight.org https://massinsight.org]

    images = []

    valid_urls.each do |url|
      images.push(Image.new(link: url))
    end

    images.each do |img|
      assert_predicate img, :valid?
      assert_not_predicate img.errors.messages[:link], :any?
    end
  end

  def test_image__invalid_if_link_is_not_valid_url
    invalid_urls = %w[https://www.massinsight https://https://www.massinsight.com http://]
    images = []

    invalid_urls.each do |url|
      images.push(Image.new(link: url))
    end

    images.each do |img|
      assert_not_predicate img, :valid?
      assert_equal 'invalid URL. Link requires http or https', img.errors.messages[:link].first
    end
  end

  def test_add_tags_to_image
    image = Image.new(link: 'https://carepharmaceuticals.com.au/wp-content/uploads/sites/19/2018/02/placeholder-600x400.png')
    image.tag_list.add('test')
    image.save

    saved_image = Image.find(image.id)
    assert_equal ['test'], saved_image.tag_list
  end

  def test_add_multiple_tags_to_image
    image = Image.new(link: 'https://carepharmaceuticals.com.au/wp-content/uploads/sites/19/2018/02/placeholder-600x400.png')
    image.tag_list.add('test', 'test2', 'test3')
    image.save

    saved_image = Image.find(image.id)
    assert_equal %w[test test2 test3], saved_image.tag_list
  end
end
