class Api::V1::ArtistsController < ApplicationController
  before_action :check_login, only: %i[show]

  def show
    render json: Artist.find(params[:id])
  end
end
