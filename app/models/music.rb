class Music < ApplicationRecord
  belongs_to :artist
  enum :genre, { rnb: "rnb", country: "country", classic: "classic", rock: "rock", jazz: "jazz" }

  validates :title, presence: true, uniqueness: true
  validates :genre,  inclusion: { in: genre.keys }, allow_nil: true
end
