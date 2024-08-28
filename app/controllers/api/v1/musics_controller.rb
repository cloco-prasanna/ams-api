class Api::V1::MusicsController < ApplicationController
  include Paginable
  before_action :check_login, only: %i[ index show create ]
  before_action :set_artist, only: %i[create update destroy]

  def index
    @musics = Music.page(current_page).per(per_page)
    render json: {
      musics: @musics,
      current_page: @musics.current_page,
      last_page: @musics.total_pages,
      prev: @musics.prev_page,
      next: @musics.next_page
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

  private

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  def music_params
    params.require(:music).permit(:title, :album_name, :genre)
  end
end
