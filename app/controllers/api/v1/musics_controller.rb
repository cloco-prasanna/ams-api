class Api::V1::MusicsController < ApplicationController
  include Paginable
  before_action :check_login, only: %i[ index show create update destroy ]
  before_action :set_artist, only: %i[index create update destroy]

  def index
    search_query = params[:search].presence
    genre = params[:genre].presence
    order_by = params[:order_by].presence || 'created_at'
    sort_order = params[:sort_order].presence || 'desc'

    musics = @artist.musics.all

    if genre
      musics = musics.where(genre: genre)
    end

    if search_query
      musics= musics.where('title ILIKE :query OR album_name ILIKE :query', query:"%#{search_query}%")
    end

    musics = musics.order("#{order_by} #{sort_order}")

    @musics = musics.page(current_page).per(per_page)
    render json: {
      musics: @musics,
      current_page: @musics.current_page,
      last_page: @musics.total_pages,
      prev: @musics.prev_page,
      next: @musics.next_page,
      totalCount: Music.count
    }
  end

  def show
    render json: Music.find(params[:id])
  end

  def create
    @music = @artist.musics.create(music_params)
    if @music
      render json: @music, status: :ok
    else
      render json: @music.errors, status: :unprocessable_entity
    end
  end

  def update
    @music = @artist.musics.find(params[:id])
    if @music.update(music_params)
      render json: @music, status: :ok
    else
      render json: @music.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @music = @artist.musics.find(params[:id])
    @music.destroy
    head 204
  end

  def genre_musics
    genreCounts = Music.group(:genre).count
    render json: {
      genres: [
        {  name: "Jazz", count: genreCounts["jazz"] },
        {  name: "Rock", count: genreCounts["rock"] },
        {  name: "Country", count: genreCounts["country"] },
        {  name: "RnB", count: genreCounts["rnb"] },
        {  name: "Classic", count: genreCounts["classic"] }
      ]
    }
  end

  private

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  def music_params
    params.require(:music).permit(:title, :album_name, :genre)
  end
end
