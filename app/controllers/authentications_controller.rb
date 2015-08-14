class AuthenticationsController < ApplicationController
  def index
  end

  def create
    # # Render omniauth hash
    # # ----------------------------------------------------
    # render :text => request.env["omniauth.auth"].to_yaml

    # Create new Authentication or redirect
    # ----------------------------------------------------
    omniauth = request.env["omniauth.auth"]
    authentication = current_user.authentication || Authentication.find_by(:provider => omniauth['provider'],
:uid => omniauth['uid'])
    if authentication
      flash[:notice] = "Already authenticated using #{authentication.provider}."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      # auth creation
      # -------------
      if omniauth['provider'] == 'clover'
        current_user.create_authentication(:provider => omniauth['provider'],
                                           :uid => omniauth['uid'],
                                           :merchant_id => omniauth['extra']['merchant_id'],
                                           :token => omniauth['credentials']['token'],
                                           :expires => false,
                                           :expires_at => nil)
        current_user.name = omniauth['info']['name']
        current_user.save!
      elsif omniauth['provider'] == 'square'
        current_user.create_authentication(:provider => omniauth['provider'],
                                           :uid => omniauth['uid'],
                                           :token => omniauth['credentials']['token'],
                                           :expires_at => Time.at(omniauth['credentials']['expires_at']).to_datetime,
                                           :expires => omniauth['credentials']['expires'])
        current_user.name = omniauth['extra']['raw_info']['name']
        current_user.save!
      end

      # Move auth creation to model
      # ---------------------------------------------------
      # current_user.authentication.create_from_omniauth(omniauth)
      flash[:notice] = "Authentication successful."
      redirect_to admin_url
    else
      redirect_to new_user_registration_url
    end
  end

  def destroy
    @authentication = current_user.authentication
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to admin_url
  end
end
