class InvitationsController < ApplicationController
before_action :authenticate_user!


  def new
    @user2 = User.find(params[:user_id])
    @invitation = Invitation.new
  end

  def index
    @invitations = Invitation.where(user2: current_user) || Invitation.where(status: "accepted")
    # They both have to be true when showing up but it's not always "accepted"
  end

  def create
    @user2 = User.find(params[:user_id])
    @invitation = Invitation.new(invitation_params)
    @invitation.user1 = current_user
    @invitation.user2 = @user2
    if @invitation.save
      redirect_to invitations_path
    else
      render 'invitations/new'
    end
  end

  def accept
    @invitation = Invitation.find(params[:id])
    @invitation.update(status: "accepted")
    redirect_to "#{invitations_path}##{@invitation.id}"
  end

  def decline
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    # (status: "declined")
    redirect_to invitations_path
    # redirect_to "#{invitations_path}##{@invitation.id}"
  end



  private

    def invitation_params
      params.require(:invitation).permit(:details, :date_time, :address)
    end
end
