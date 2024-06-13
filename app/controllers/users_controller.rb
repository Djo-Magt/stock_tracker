class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
    if params[:query].present?
      @users = User.all.search_by_first_and_last_name_excluding_current_user(params[:query], current_user.id)
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

end
