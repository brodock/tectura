class Local < ActiveRecord::Base
  scope :states, :select => "distinct(states)", :order => "states"
  
  def self.cities_of(state)
    Local.all(:conditions => {:states => state}, :order => 'city')
  end
end