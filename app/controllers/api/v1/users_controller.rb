class Api::V1::UsersController < ApplicationController
  include Paginable
    before_action :set_user, only: %i[show update destroy]
    before_action :check_login, only: %i[update destroy]

    # GET /users
    def index
      @users = User.page(current_page).per(per_page)
      render json: {
        users: @users,
        current_user: @users.current_page,
        last_page: @users.total_pages,
        prev: @users.prev_page,
        next: @users.next_page
      }
    end

    # GET /user
    def show
        render json: User.find(params[:id])
    end

    # POST /users
    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def update
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      head 204
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name, :phone, :gender, :address)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_owner
      head :forbidden unless @user.id == current_user&.id
    end
end
