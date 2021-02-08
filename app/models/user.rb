class User < ApplicationRecord

  after_create :set_global

  # (Auth) Devise Modules

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Validations

  validates :email, presence: true, uniqueness: true

  # Associations

  has_many :books, dependent: :destroy

  private
    def set_global
      self.books.create( name:'Global', global:true )
    end
end
