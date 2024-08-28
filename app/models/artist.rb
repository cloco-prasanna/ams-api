class Artist < ApplicationRecord
  enum gender: { male: "male", female: "female", other: "other" }
  validates :name, uniqueness: true
  validates :gender, presence: true, inclusion: { in: genders.keys }
end
