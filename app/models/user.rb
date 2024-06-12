class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  include PgSearch::Model

  pg_search_scope :search_by_first_and_last_name,
    against: [ :first_name, :last_name ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  def self.search_by_first_and_last_name_excluding_current_user(query, current_user_id)
    search_by_first_and_last_name(query).where.not(id: current_user_id)
  end

  def not_friends_with?(id_friends)
    !friends.where(id: id_friends).exists?
  end

end
