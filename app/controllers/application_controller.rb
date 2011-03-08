# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_user_login, :except=>[:welcome,:sign_in,:process_sign_in,:new,:create]
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  private
  
  def check_user_login
    if session[:current_user].blank?
      flash[:error] = "Please sign in to continue."
      redirect_to :controller=>'users', :action=>'sign_in'
      return false
    else
      @user = User.find(session[:current_user_id])
      @properties = @user.properties
      return true
    end
  end

  def has_permission
    unless @user.blank? || !@user.is_admin.eql?(1)
      return true
    else
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>'users', :action=>'sign_in'
    end
  end

  def user_is_admin?
    return false if @user.blank?
    return @user.is_admin.eql?(1) ? true : false
  end

  def user_is_owner?(id)
    return false if @user.blank?
    return @user.id.eql?(id) ? true : false
  end
end
