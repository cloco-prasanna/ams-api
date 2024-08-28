class Artist < ApplicationRecord
  has_many :musics
  enum :gender, { male: "male", female: "female", other: "other" }

  validates :name, presence: true, uniqueness: true
  validates :gender, presence: true, inclusion: { in: genders.keys }
end
