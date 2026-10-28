# frozen_string_literal: true

require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:one)
    @message = messages(:one)

    sign_in users(:one)
  end

  test "should create message" do
    assert_difference("Message.count") do
      post room_messages_url(@room), params: { message: { message: "Hello" } }, as: :turbo_stream
    end

    assert_turbo_stream action: "replace", target: "new_message_form"
  end

  test "should not create empty message" do
    assert_no_difference("Message.count") do
      post room_messages_url(@room), params: { message: { message: "" } }, as: :turbo_stream
    end

    assert_response :unprocessable_entity
  end

  test "should update message" do
    patch room_message_url(@room, @message), params: { message: { message: "Edited" } }, as: :turbo_stream

    assert_turbo_stream action: "replace", target: dom_id(@message)
    assert_equal "Edited", @message.reload.message
  end

  test "should destroy message" do
    assert_difference("Message.count", -1) do
      delete room_message_url(@room, @message), as: :turbo_stream
    end

    assert_turbo_stream action: "remove", target: dom_id(@message)
  end

  test "should not find message through another room" do
    get edit_room_message_url(rooms(:two), @message)

    assert_response :not_found
  end

  test "should redirect guests to sign in" do
    sign_out users(:one)

    assert_no_difference("Message.count") do
      delete room_message_url(@room, @message)
    end

    assert_redirected_to new_user_session_url
  end
end
