# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit :room_messages_create
  after_update_commit :room_messages_update

  private

  def room_messages_create
    broadcast_append_to(
      "room_messages_channel",
      partial: "messages/message",
      locals: { message: self },
      target: "room_messages_div"
    )
  end

  def room_messages_update
    broadcast_replace_to(
      "room_messages_channel",
      partial: "messages/message",
      locals: { message: self },
      target: "message_#{id}"
    )
  end
end
