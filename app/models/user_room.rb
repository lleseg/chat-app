# frozen_string_literal: true

class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_destroy_commit :remove_room_from_member

  private

  def remove_room_from_member
    broadcast_remove_to [user, :rooms], target: "room_#{room_id}"
    broadcast_remove_to [user, :rooms], target: "room_show_#{room_id}"
  end
end
