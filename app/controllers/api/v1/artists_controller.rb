require "csv"
class Api::V1::ArtistsController < ApplicationController
  include Paginable
  before_action :check_login, only: %i[index show create update destroy import]
  before_action :set_artist, only:  %i[update destroy ]

  def index
    search_query = params[:search].presence
    order_by = params[:order_by].presence || 'created_at'
    sort_order = params[:sort_order].presence || 'desc'

    artists  = Artist.all

    if search_query
      artists = artists.where('name ILIKE :query', query: "%#{search_query}%")
    end

    artists = artists.order("#{order_by} #{sort_order}")

    @artists = artists.page(current_page).per(per_page)

    render json: {
      artists: @artists,
      current_page: @artists.current_page,
      last_page: @artists.total_pages,
      prev: @artists.prev_page,
      next: @artists.next_page,
      totalCount: Artist.count
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
    if params[:file].present?
      file = params[:file].tempfile
      csv_data = CSV.read(file, headers: true)

      artists = csv_data.map do |row|
        {
          name: row["name"],
          dob: row["dob"],
          gender: row["gender"],
          address: row["address"],
          first_release_year: row["first_release_year"],
          no_of_albums_released: row["no_of_albums_released"]
        }
      end
      Artist.create(artists)

    render json: artists, status: :ok
    else
    render json: { error: "Upload failed" }, status: :unprocessable_entity
    end
  end


  def artist_analytics
    @artists = Artist.
    render json: {
      artists: @artists,
      current_page: @artists.current_page,
      last_page: @artists.total_pages,
      prev: @artists.prev_page,
      next: @artists.next_page,
      totalCount: Artist.count
    }
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
