class AuthenticationsController < ApplicationController
  def index
  end

  def create
    # Render omniauth hash
    # ----------------------------------------------------
    render :text => request.env["omniauth.auth"].to_yaml

    # Create new Authentication or redirect
    # ----------------------------------------------------
#     omniauth = request.env["omniauth.auth"]
#     authentication = current_user.authentication || Authentication.find_by(:provider => omniauth['provider'],
# :uid => omniauth['uid'])
#     if authentication
#       flash[:notice] = "Already authenticated using #{authentication.provider}."
#       sign_in_and_redirect(:user, authentication.user)
#     elsif current_user
#       # auth creation
#       # -------------
#       current_user.create_authentication(:provider => omniauth['provider'],
# :uid => omniauth['uid'])
#       # Move auth creation to model
#       # ---------------------------------------------------
#       # current_user.authentication.create_from_omniauth(omniauth)
#       flash[:notice] = "Authentication successful."
#       redirect_to root_url
#     else
#       redirect_to new_user_registration_url
#     end
  end

  def destroy
  end
end
