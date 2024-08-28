class Artist < ApplicationRecord
  has_many :musics
  enum :gender, { male: "male", female: "female", other: "other" }

  validates :name, presence: true, uniqueness: true
  validates :gender, inclusion: { in: genders.keys }, allow_nil: true
end
