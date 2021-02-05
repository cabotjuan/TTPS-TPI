class Book < ApplicationRecord

  # Validations

  validates :name, presence: true, uniqueness: { scope: :user_id }

  # Associations 

  belongs_to :user
  has_many :notes
  
end
