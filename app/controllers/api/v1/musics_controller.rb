class Api::V1::MusicsController < ApplicationController
  include Paginable
  before_action :check_login, only: %i[ index show ]

  def index
    render json: Music.all
  end
  def show
    @musics = Music.page(current_page).per(per_page)
    render json: {
      musics: @musics,
      current_page: @musics.current_page,
      last_page: @musics.total_pages,
      prev: @musics.prev_page,
      next: @musics.next_page
    }
  end
end
