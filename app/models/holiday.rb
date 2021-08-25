# frozen_string_literal: true

# frozen_string_literal: true

# == Schema Information
#
# Table name: holidays
#
#  id                  :bigint           not null, primary key
#  date                :date             not null
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  monthly_forecast_id :bigint
#
# Indexes
#
#  index_holidays_on_date                 (date) UNIQUE
#  index_holidays_on_monthly_forecast_id  (monthly_forecast_id)
#
# Foreign Keys
#
#  fk_rails_...  (monthly_forecast_id => monthly_forecasts.id)
#
class Holiday < ApplicationRecord
  # callbacks
  before_validation :format_fields

  # association
  belongs_to :monthly_forecast

  # validations
  validates :date, presence: true

  private

  # format fields before saving
  #   - strip whitespace
  #   - downcase
  def format_fields
    self.name = name.strip.downcase if name.present?
  end
end
