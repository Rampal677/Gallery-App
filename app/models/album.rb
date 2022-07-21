class Album < ApplicationRecord
  belongs_to :user
  has_one_attached :cover
  has_many_attached :images
  has_many :taggings , dependent: :destroy
  has_many :tags, through: :taggings
  validates :name,:price, :description, presence: true
  validates :name, length: { in: 2..15 }
  validates :price, length: { in: 1..6 }

  paginates_per 5
  def self.tagged_with(name)
    Tag.find_by!(name: name).posts
  end

  def self.tag_counts
    Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
