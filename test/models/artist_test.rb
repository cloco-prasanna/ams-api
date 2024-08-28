require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "artist with a valid gender should be valid" do
    artist  = Artist.new(name: "dfdsf", gender: "male")
    assert artist.valid?
  end

  test "artist with no name should be invalid" do
    artist = Artist.new(gender: "male")
    assert_not artist.valid?
    assert_includes artist.errors[:name], "can't be blank"
  end

  test "artist with invalid gender should be invalid " do
    artist = Artist.new(name: "test", gender: "dsdf")
    assert_not artist.valid?
    assert_includes artist.errors[:gender], " is not a valid gender"
  end
end
