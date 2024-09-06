require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(
      email: "test@example.com",
      password: "password123",
      first_name: "John",
      last_name: "Doe",
      gender: "male"
    )
  }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a valid email format' do
      subject.email = 'invalidemail'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password_digest = nil
      expect(subject).to_not be_valid
    end
  end
end
