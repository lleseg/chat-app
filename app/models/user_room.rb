# frozen_string_literal: true

class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit :add_room_to_member
  after_destroy_commit :remove_room_from_member

  private

  def add_room_to_member
    broadcast_append_later_to [user, :rooms], target: "rooms", partial: "shared/room", locals: { room: }
    broadcast_replace_later_to room, target: [room, :show], partial: "rooms/room", locals: { room: }
  end

  def remove_room_from_member
    broadcast_remove_to [user, :rooms], target: room
    broadcast_remove_to [user, :rooms], target: [room, :show]
  end
end
