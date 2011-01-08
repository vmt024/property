# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_user_login, :except=>[:welcome,:sign_in,:new]
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
  
  def check_user_login
    if session[:current_user].blank?
      flash[:error] = "Please sign in to continue."
      redirect_to :controller=>'users', :action=>'sign_in'
    else
      return true
    end
  end
end
