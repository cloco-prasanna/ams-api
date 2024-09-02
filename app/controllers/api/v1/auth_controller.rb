class Api::V1::AuthController < ApplicationController
  def login
    @user  = User.find_by_email(login_params[:email])
    if @user&.authenticate(login_params[:password])
      render json: {
        token: JsonWebToken.encode(user_id: @user.id,   role: @user.role)
      }
    else
      head :unauthorized
    end
  end

  def register
    @user = User.new(register_params.merge(role:  "user"))
    if @user.save
        render json: @user, status: :created
    else
        render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def register_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :dob, :phone, :gender, :address)
  end
end
