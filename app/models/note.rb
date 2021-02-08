class Note < ApplicationRecord
    
  # Validations

  validates :name, presence: true, uniqueness: { scope: :book_id }
  validates :book, presence: true
  
  # Associations

  belongs_to :book
  
end
