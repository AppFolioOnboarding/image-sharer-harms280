require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  def test_show
    get tag_url('tag1')

    assert_response :ok
    assert_select '#header', 'Images associated with tag: tag1'
  end

  def test_show__images_associated_with_tag_appear
    Image.create(link: 'https://www.massinsight.org/wp-content/uploads/2016/05/placeholder-4-500x300.png',
                 tag_list: 'tag1, tag2')
    Image.create(link: 'https://picsum.com/photos/200/300/?image=290', tag_list: 'tag2, tag3')

    get tag_url('tag1')

    assert_select 'img' do |images|
      assert_equal 1, images.count
      assert_equal 'https://www.massinsight.org/wp-content/uploads/2016/05/placeholder-4-500x300.png',
                   images[0][:src]
    end
  end
end
