class Note < ApplicationRecord
    
  # Validations

  validates :name, presence: true, uniqueness: { scope: :book_id }

  # Associations

  belongs_to :book
  
end
