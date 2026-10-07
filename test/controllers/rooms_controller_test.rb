# frozen_string_literal: true

require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:one)

    sign_in users(:one)
  end

  test "should get index" do
    get rooms_url
    assert_response :success
  end

  test "should show room" do
    get room_url(@room)
    assert_response :success
  end

  test "should get new" do
    get new_room_url
    assert_response :success
  end

  test "should get edit" do
    get edit_room_url(@room)
    assert_response :success
  end

  test "should create room" do
    assert_difference("Room.count") do
      post rooms_url, params: { room: { name: @room.name } }, as: :turbo_stream
    end

    assert_turbo_stream action: "append", target: "rooms"
    assert_turbo_stream action: "replace", target: "room_form"
  end

  test "should update room" do
    patch room_url(@room), params: { room: { name: @room.name } }, as: :turbo_stream
    assert_turbo_stream action: "replace", target: "room_#{@room.id}"
  end

  test "should destroy room" do
    assert_difference("Room.count", -1) do
      delete room_url(@room), as: :turbo_stream
    end

    assert_turbo_stream action: "remove", target: "room_#{@room.id}"
    assert_turbo_stream action: "remove", target: "room_show_#{@room.id}"
  end
end
