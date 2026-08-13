class Invoice < ApplicationRecord
  belongs_to :corrects_invoice
  belongs_to :organization
  belongs_to :client
end
