class ForecastRequest
  include ActiveModel::Model

  attr_accessor :street, :city, :state, :zip_code

  validates :street, :city, :state, :zip_code, presence: true
  validates :zip_code, numericality: { only_integer: true }
  validates :zip_code, length: { is: 5 }
  validates :state, length: { is: 2 }
end

