require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  test "should get caption" do
    get :caption
    assert_response :success
  end

end
