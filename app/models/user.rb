class User < ApplicationRecord
  has_many :albums
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
end
