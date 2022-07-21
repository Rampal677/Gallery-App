class Tag < ApplicationRecord
    has_many :taggings , dependent: :destroy
    has_many :albums , through: :taggings
end
