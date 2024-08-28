class Api::V1::ArtistsController < ApplicationController
  include Paginable
  before_action :check_login, only: %i[index show create update destroy import]
  before_action :set_artist, only:  %i[update destroy ]

  def index
    @artists = Artist.page(current_page).per(per_page)
    render json: {
      artists: @artists,
      current_page: @artists.current_page,
      last_page: @artists.total_pages,
      prev: @artists.prev_page,
      next: @artists.next_page
    }
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
    if @artist.update(artist_params)
      render json: @artist, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @artist.destroy
    head 204
  end

  def import
    artists = params[:artists]
    if artists.present?
      begin
        artists.each do |artist_params|
          artist = Artist.new(artist_params.permit(:name, :genre, :gender, :address, :first_release_year, :no_of_albums_released))
          artist.save!
        end
        render json: { message: "Artist imported" }, status: :ok
        rescue StandardError => e
          render json: { message: e.message }, status: :unprocessable_entity
        end
    else
        render json: { message: "No data provided " }, status: :unprocessable_entity

    end
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
