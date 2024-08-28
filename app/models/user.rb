class User < ApplicationRecord
    enum :gender, { male: "male", female: "female", other: "other" }

    validates :email, uniqueness: true
    validates_format_of :email, with: /@/
    validates :password_digest, presence: true
    validates :gender, inclusion: { in: genders.keys }
    has_secure_password
end
