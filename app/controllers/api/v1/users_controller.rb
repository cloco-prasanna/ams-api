class Api::V1::UsersController < ApplicationController
  include Paginable
    before_action :set_user, only: %i[show update destroy]
    before_action :check_login, :check_owner, only: %i[update destroy]
    before_action :check_isadmin, only: %i[create]

    # GET /users
    def index
      search_query = params[:search].presence
      order_by = params[:order_by].presence || 'created_at'
      sort_order = params[:sort_order].presence || 'desc'

      users = User.all

      total_count = users.count
    
      if search_query
        users = users.where('email ILIKE :query OR first_name ILIKE :query OR last_name ILIKE :query', query: "%#{search_query}%")
      end
    
      users = users.order("#{order_by} #{sort_order}")
    
      @users = users.page(current_page).per(per_page)
    
      render json: {
        users: @users,
        current_page: @users.current_page,
        last_page: @users.total_pages,
        prev: @users.prev_page,
        next: @users.next_page,
        totalCount: User.count
      }
    end
    # GET /user
    def show
        render json: User.find(params[:id])
    end

    # POST /users
    def create
      user_with_default_role = user_params.merge(role: user_params[:role] || "user")
        @user = User.new(user_with_default_role)
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
        params.require(:user).permit(:email, :password, :first_name, :last_name, :dob, :phone, :gender, :address, :role)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_owner
      head :forbidden unless @user.id == current_user&.id || current_user&.role=="admin"
    end
end
