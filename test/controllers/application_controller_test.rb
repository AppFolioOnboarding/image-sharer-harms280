require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def test_add_active_class
    get new_image_path
    assert_select '.nav-item.active a', 'New'
  end
end
