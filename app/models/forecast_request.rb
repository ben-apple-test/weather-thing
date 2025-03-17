class ForecastRequest
  include ActiveModel::Model
  include StateNames

  attr_accessor :street, :city, :state, :zip_code

  validates :street, :city, :state, :zip_code, presence: true
  validates :state, presence: true
  validates :state, inclusion: { in: STATE_NAMES, message: "is not a valid state" }
  validates :zip_code, presence: true,
                      numericality: { only_integer: true },
                      length: { is: 5 }
  validate :validate_zip_code

  def attributes
    {
      street: street,
      city: city,
      state: state,
      zip_code: zip_code
    }
  end

  # Checks our database of US zip codes
  def validate_zip_code
    unless ZipCode.exists?(code: zip_code)
      errors.add(:zip_code, "is not a known zip code")
    end
  end
end
