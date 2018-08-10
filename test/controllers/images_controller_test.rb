require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_new
    get new_image_url
    assert_response :success
  end

  def test_show
    get image_url(1)
    assert_response :success
  end
end
