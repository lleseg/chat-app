# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :set_message, only: %i[edit update destroy]

  def create
    @message = @room.messages.new(message_params)
    @message.user = current_user

    if @message.save
      render turbo_stream: turbo_stream.replace("new_message_form", partial: "messages/form",
                                                                    locals: { room: @room, message: Message.new })
    else
      render turbo_stream: turbo_stream.replace("new_message_form", partial: "messages/form",
                                                                    locals: { room: @room, message: @message }),
             status: 422
    end
  end

  def edit; end

  def update
    if @message.update(message_params)
      render turbo_stream: turbo_stream.replace(@message, partial: "messages/message", locals: { message: @message })
    else
      render :edit, status: 422
    end
  end

  def destroy
    @message.destroy

    render turbo_stream: turbo_stream.remove(@message)
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_message
    @message = @room.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:message)
  end
end
