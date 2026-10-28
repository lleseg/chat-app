# frozen_string_literal: true

class Message < ApplicationRecord
  validates :message, presence: true

  belongs_to :user
  belongs_to :room

  after_create_commit :room_messages_create
  after_update_commit :room_messages_update
  after_destroy_commit :room_messages_destroy

  private

  def room_messages_create
    broadcast_append_later_to room, target: [room, :messages], partial: "messages/message", locals: { message: self }
  end

  def room_messages_update
    broadcast_replace_later_to room, target: self, partial: "messages/message", locals: { message: self }
  end

  def room_messages_destroy
    broadcast_remove_to room, target: self
  end
end
