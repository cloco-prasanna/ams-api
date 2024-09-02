module Authenticable
  def current_user
    return @current_user if @current_user

    header = request.headers["Authorization"]
    return nil if header.nil?
    token = header.split(" ").last

    decoded = JsonWebToken.decode(token)


    @current_user = User.find(decoded[:user_id]) rescue ActiveRecord::RecordNotFound
  end

  protected

  def check_isadmin
    puts self.current_user
    head :forbidden unless self.current_user&.role=="admin"
  end

  def check_login
    head :forbidden unless self.current_user
  end
end
