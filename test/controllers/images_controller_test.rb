# rubocop:disable Metrics/ClassLength
require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = create_image
  end

  def test_index
    image2 = create_image(link: 'http://www.qygjxz.com/data/out/193/4949794-random-image.jpg')

    get images_url

    assert_response :ok
    assert_select '.card__img' do |images|
      assert_equal image2.link, images.first[:src]
      assert_equal @image.link, images.last[:src]
    end
  end

  def test_new
    get new_image_url
    assert_response :ok
    assert_select '#header', 'Create new Image!'
  end

  def test_show
    get image_url(@image)

    assert_response :ok
    assert_select '#header', 'Show Image'
  end

  def test_show__redirects_to_images_if_image_does_not_exist
    get image_url(-1)

    assert_response :redirect
    assert_redirected_to images_path
    follow_redirect!
    assert_select '.alert-warning', 'Image does not exist.'
  end

  def test_create__succeed
    assert_difference('Image.count', 1) do
      image_params = { link: 'https://picsum.com/photos/200/300/?image=290', tag_list: 'tag1, tag2, tag3' }
      post images_url, params: { image: image_params }

      assert_redirected_to image_path(Image.last)
      follow_redirect!

      assert_select '.tag-list li' do |tags|
        assert_equal 'tag1', tags[0].text
        assert_equal 'tag2', tags[1].text
        assert_equal 'tag3', tags[2].text
      end
    end
  end

  def test_create__fail
    assert_no_difference('Image.count') do
      image_params = { link: '', tag_list: 'tag1, tag2, tag3' }
      post images_path, params: { image: image_params }
    end

    assert_response :unprocessable_entity
    assert_select '.invalid-feedback', "Link can't be blank and Link invalid URL. Link requires http or https"
  end

  def test_edit
    get edit_image_url(@image)

    assert_response :ok
    assert_select '#header', 'Edit Image!'
  end

  def test_update__success
    image_params = { tag_list: 'updatedTag1, updatedTag2' }

    put image_url(@image), params: { image: image_params }

    assert_redirected_to image_path(@image)
    follow_redirect!

    assert_select '.tag-list li' do |tags|
      assert_equal 'updatedTag1', tags[0].text
      assert_equal 'updatedTag2', tags[1].text
    end
    assert_select '.alert-success', 'You have successfully updated an image'
  end

  def test_update__fail
    image_params = { tag_list: '' }

    put image_url(@image), params: { image: image_params }

    assert_response :unprocessable_entity
    assert_select '.invalid-feedback', "Tag list can't be blank"
  end

  def test_destroy
    assert_difference('Image.count', -1) do
      delete image_path(@image)
    end

    assert_redirected_to images_path
    follow_redirect!
    assert_select '.alert-success', 'You have successfully deleted the image.'
  end

  def test_destroy__cannot_destroy_image_that_does_not_exist
    assert_difference('Image.count', 0) do
      delete image_path(-1)
    end

    assert_response :redirect
    assert_redirected_to images_path
    follow_redirect!

    assert_select '.alert-warning', 'Image does not exist.'
  end

  def test_show_images_associated_with_tag
    Image.create(link: 'https://www.massinsight.org/wp-content/uploads/2016/05/placeholder-4-500x300.png',
                 tag_list: 'tag1, tag2')
    Image.create(link: 'https://picsum.com/photos/200/300/?image=290', tag_list: 'tag2, tag3')

    get images_url(tag: 'tag1')

    assert_select 'img' do |images|
      assert_equal 1, images.count
      assert_equal 'https://www.massinsight.org/wp-content/uploads/2016/05/placeholder-4-500x300.png',
                   images[0][:src]
    end
  end

  def test_send_share_email__success
    params = { id: @image[:id], share_email: { address: 'friend@example.com',
                                               message: 'This is a message to send the person' } }
    post share_url(@image), xhr: true, params: params

    assert_response :ok
    assert_equal '[["success","Email has been successfully sent"]]', @response.body
  end

  def test_send_share_email__fail
    params = { id: @image[:id], share_email: { address: '', message: 'This is a message to send the person' } }
    post share_url(@image), xhr: true, params: params

    assert_response :unprocessable_entity
    assert_equal "{\"errors\":{\"address\":[\"can't be blank\",\"has invalid format\"]}," \
                 '"flash":[["danger","Form requires a valid email"]]}',
                 @response.body
  end

  private

  def create_image(link: 'https://carepharmaceuticals.com.au/wp-content/uploads/sites/19/2018/02/placeholder-600x400.png',
                   tag_list: 'tag1 tag2 tag3')
    Image.create!(link: link, tag_list: tag_list)
  end
end

# rubocop:enable Metrics/ClassLength
