class Person < Sequel::Model(:people)
  def eta
    ((self.arrival_time - Time.now)/60.0).ceil
  end
end
