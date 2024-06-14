class UserStocksController < ApplicationController

  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      if stock.save
        flash[:notice] = "Stock #{stock.name} added"
      else
        flash[:alert] = "There was an error saving the stock"
        redirect_to my_portfolio_path and return
      end
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} ajouté"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} remove"
    redirect_to my_portfolio_path
  end
end
