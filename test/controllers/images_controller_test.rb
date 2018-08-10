require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_new
    get new_image_url
    assert_response :success
  end

  def test_show
    get image_url(Image.first[:id])

    assert_response :ok
    assert_select '#header', 'Show Image'
  end
end
