class ForecastRequest
  include ActiveModel::Model

  attr_accessor :street, :city, :state, :zip_code

  validates :street, :city, :state, :zip_code, presence: true
  validates :zip_code, numericality: { only_integer: true }
  validates :zip_code, length: { is: 5 }
  validate :validate_zip_code
  validates :state, presence: true
  validates :state, length: { is: 2 }

  def attributes
    {
      street: street,
      city: city,
      state: state,
      zip_code: zip_code
    }
  end

  def validate_zip_code
    unless ZipCode.exists?(code: zip_code)
      errors.add(:zip_code, 'is not a known zip code')
    end
  end 
end

