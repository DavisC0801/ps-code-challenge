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

  def determine_category
    prefix = self.post_code.slice(0,3)
    if prefix == "LS1"
      chairs = self.number_of_chairs
      if chairs < 10
        self.category = 'ls1 small'
      elsif chairs < 100
        self.category = 'ls1 medium'
      else
        self.category = "ls1 large"
      end
    elsif prefix == "LS2"
      self.category = "ls2 small"
      self.category = "ls2 large"
      # todo - impliment percentile function
      # of chairs below the 50th percentile for ls2: category = 'ls2 small'
      # of chairs above the 50th percentile for ls2: category = 'ls2 large'
    else
      self.category = 'other'
    end
    self.save()
  end
end
