class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :saml

  def saml
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
    else
      flash[:alert] = "User not found. Please contact the administrator."
      failure
    end
  end

  def failure
    redirect_to root_path
  end
end
