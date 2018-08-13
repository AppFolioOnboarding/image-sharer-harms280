require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_new
    get new_image_url
    assert_response :ok
    assert_select '#header', 'Create new Image!'
  end

  def test_show
    get image_url(Image.first)

    assert_response :ok
    assert_select '#header', 'Show Image'
  end

  def test_create__succeed
    assert_difference('Image.count', 1) do
      image_params = { link: 'https://picsum.com/photos/200/300/?image=290' }
      post images_url, params: { image: image_params }
      assert_redirected_to image_path(Image.last)
    end
  end

  def test_create__fail
    assert_no_difference('Image.count') do
      image_params = { link: '' }
      post images_path, params: { image: image_params }
    end

    assert_response :unprocessable_entity
    assert_select '#link-error', "Link can't be blank"
  end
end
