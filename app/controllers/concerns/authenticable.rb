module Authenticable
  def current_user
    return @current_user if @current_user

    header = request.headers["Authorization"].split(" ").last
    return nil if header.nil?

    decoded = JsonWebToken.decode(header)


    @current_user = User.find(decoded[:user_id]) rescue ActiveRecord::RecordNotFound
  end

  protected

  def check_login
    head :forbidden unless self.current_user
  end
end
