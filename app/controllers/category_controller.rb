class CategoryController < ApplicationController
  def index
    @category_stats = Restaurant.find_category_stats
  end
end
