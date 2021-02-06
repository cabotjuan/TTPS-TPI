class Book < ApplicationRecord

  # Validations

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user, presence: true
  
  # Associations 

  belongs_to :user
  has_many :notes
  
end
