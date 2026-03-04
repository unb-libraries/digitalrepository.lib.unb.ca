class Admin::UsersController < Hyrax::Admin::UsersController
  def create
    @user = User.create uid: params[:users][:uid], provider: "saml"
    redirect_to admin_users_url, alert: "User #{@user.uid} successfully added."
  end

  def new
  end
end
