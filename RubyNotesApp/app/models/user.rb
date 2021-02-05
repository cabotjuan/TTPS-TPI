class User < ApplicationRecord
  
  # (Auth) Devise Modules

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Validations

  validates :email, presence: true, uniqueness: true

  # Associations

  has_many :books

end
