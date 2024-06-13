class FriendshipsController < ApplicationController

  def create
    friend = User.find(params[:friend_id])
    current_user.friends << friend

    if current_user.save
      flash[:notice] = "follow"
    else
      flash[:notice] = "something wrong"
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "unfollow"
    redirect_to my_friends_path
  end

end
