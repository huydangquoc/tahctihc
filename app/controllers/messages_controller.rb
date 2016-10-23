class MessagesController < ApplicationController
  def index
    @messages = Message.belong_to_me(current_user).order(created_at: :desc)
  end

  def show
    @message = Message.find params[:id]
    if current_user == @message.recipient
      if !@message.read?
        @message.mark_as_read!
      else
        redirect_to messages_path, notice: "You read it already, no way to read it again, baby!"
      end
    else
      redirect_to messages_path, notice: "You're very SNEAKY, bad, it's really bad."
    end
  end

  def new
    @users = User.all_except(current_user)
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id

    if @message.save
      redirect_to sent_messages_path, flash: {success: "Message sent successfully."}
    else
      @users = User.all_except(current_user)
      render 'new'
    end
  end

  def sent
    @messages = Message.sent_by_me(current_user).order(created_at: :desc)

    selected_message_index = params[:message_id]
    if @messages.count > 0
      if !selected_message_index.nil?
        @selected_message = @messages.find(selected_message_index)
      else
        @selected_message = @messages.first
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :body)
  end

end
