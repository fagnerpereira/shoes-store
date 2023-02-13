require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url

    assert_equal 'index', @controller.action_name
    # assert_equal 'application/x-www-form-urlencoded', @request.media_type
    # assert_match 'Stores', @response.body
  end
end
