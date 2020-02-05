class RestaurantController < ApplicationController
  def index
    @post_code_stats = Restaurant.find_post_code_stats
    @seat_stats = Restaurant.find_seat_stats
  end
end
