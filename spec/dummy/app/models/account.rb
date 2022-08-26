class Account < ApplicationRecord
  validates :vat_number, length: {maximum: 20}
end
