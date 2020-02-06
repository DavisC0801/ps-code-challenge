class Restaurant < ApplicationRecord
  validates_presence_of :name, :address, :post_code, :number_of_chairs

  def self.find_post_code_stats
    select("post_code, COUNT(id) AS total_places, SUM(number_of_chairs) AS total_chairs, (SUM(number_of_chairs)*100.0)/(SELECT SUM(number_of_chairs) FROM restaurants) AS chairs_pct")
    .group(:post_code)
    .order(:post_code)
  end

  def self.find_seat_stats
    select("name AS place_with_max_chairs, MAX(number_of_chairs) AS max_chairs")
    .where("ROW(post_code, number_of_chairs) IN (SELECT post_code, MAX(number_of_chairs) FROM restaurants GROUP BY post_code)")
    .group(:post_code, :name)
    .order(:post_code)
  end

  def self.find_category_stats
    select("category, COUNT(id) AS total_places, SUM(number_of_chairs) AS total_chairs")
    .group(:category)
    .order(category: :desc)
  end

  def determine_category
    prefix = self.post_code.slice(0,4)
    if prefix == "LS1 "
      chairs = self.number_of_chairs
      if chairs < 10
        self.category = 'ls1 small'
      elsif chairs < 100
        self.category = 'ls1 medium'
      else
        self.category = "ls1 large"
      end
    elsif prefix == "LS2 "
      average_seats = Restaurant.where(["post_code LIKE ?", "LS2%"]).unscope(:order).average(:number_of_chairs).to_f
      if self.number_of_chairs < average_seats
        self.category = "ls2 small"
      else
        self.category = "ls2 large"
      end
    else
      self.category = 'other'
    end
    self.save
  end

  def self.export_small
    small_restaurants = self.where(["category LIKE ?", "%small"]).unscope(:order)
    if !small_restaurants.empty?
      CSV.open("./Small Cafes 2015-16.csv", "w") do |csv|
        small_restaurants.each do |restaurant|
          csv << [restaurant.name, restaurant.address, restaurant.post_code, restaurant.number_of_chairs, restaurant.category]
          restaurant.destroy()
        end
      end
    end
  end

  def self.rename_large
    large_restaurants = self.where(["category LIKE ?", "%large"]).unscope(:order)
    # small check to prevent task being ran multiple times, unlikely first and last will both be named after the category
    if !large_restaurants.first.name.include?(large_restaurants.first.category) && !large_restaurants.last.name.include?(large_restaurants.last.category)
      large_restaurants.each do |restaurant|
        restaurant.update(name: "#{restaurant.category} #{restaurant.name}")
      end
    end
  end
end
