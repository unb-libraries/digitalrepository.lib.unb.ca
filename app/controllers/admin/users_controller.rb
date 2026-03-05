class Admin::UsersController < Hyrax::Admin::UsersController
  def index
    super
    render :index
  end

  def create
    @user = User.create uid: params[:users][:uid], provider: "saml"
    redirect_to admin_users_url, alert: "User #{@user.uid} successfully added."
  end

  def new
    add_breadcrumb t(:'hyrax.controls.home'), root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb t(:'hyrax.admin.users.index.title'), admin_users_path
  end
end
