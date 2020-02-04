class Restaurant < ApplicationRecord
  validates_presence_of :name, :address, :post_code, :number_of_chairs
  def determine_category()
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
