class RestaurantController < ApplicationController
  def index
    @statistics_by_post_code = Restaurant.find_post_code_stats
  end
end
