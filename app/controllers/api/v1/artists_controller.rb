class Api::V1::ArtistsController < ApplicationController
  before_action :check_login, only: %i[show create update destroy]
  before_action :set_artist, only:  %i[update destroy]

  def index
    render json: Artist.all
  end

  def show
    render json: Artist.find(params[:id])
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      render json: @artist, status: :created
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  def update
    if @artist.update(user_params)
      render json: @artist, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @artist.destroy
    head 204
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
