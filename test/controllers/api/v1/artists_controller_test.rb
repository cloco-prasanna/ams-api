require "test_helper"

class Api::V1::ArtistsControllerTest < ActionDispatch::IntegrationTest
 setup do
   @artist = artists(:one)
 end


 test "should show artist" do
   get api_v1_artist_url(@artist), as: :json
   assert_response :success
   json_response = JSON.parse(self.response.body)
   assert_equal @artist.name, json_response["name"]
 end
end
