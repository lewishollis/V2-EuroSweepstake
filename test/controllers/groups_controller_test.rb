require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get groups_show_url
    assert_response :success
  end

  test "should get update" do
    get groups_update_url
    assert_response :success
  end

  test "should get calculate_score" do
    get groups_calculate_score_url
    assert_response :success
  end

  test "should get index" do
    get groups_index_url
    assert_response :success
  end
end
