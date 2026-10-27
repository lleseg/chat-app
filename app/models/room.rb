# frozen_string_literal: true

class Room < ApplicationRecord
  validates :name, presence: true

  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms
  has_many :messages

  after_update_commit :broadcast_room_to_members

  private

  def broadcast_room_to_members
    broadcast_replace_later_to self, target: [self, :show], partial: "rooms/room", locals: { room: self }

    users.each do |user|
      broadcast_replace_later_to [user, :rooms], target: self, partial: "shared/room", locals: { room: self }
    end
  end
end
