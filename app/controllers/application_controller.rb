# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  include PathHelper
  include MonitorshipsHelper
  include ReCaptcha::AppHelper

  helper :all
  helper_method :current_page,:can_comment?
#  before_filter :set_language
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e125a4be589f9d81263920581f6e4182'

  # raised in #current_site
  rescue_from Site::UndefinedError do |e|
    redirect_to new_site_path
  end

  def can_comment?
    !logged_in? || current_user.active?
  end

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

  protected


  def spambot_filter
    if (params[:extra] != nil && !params[:extra].empty?)
      redirect_to root_url
    end 
  end
  
  def login_filter
    unless params[:confirmation].nil? || params[:confirmation].empty?
      redirect_to root_url
    else
      if !logged_in?
        unless params["user"]["password_confirmation"].nil? || params["user"]["password_confirmation"].empty?
          user = create_user false
          password_authentication( user.login.downcase, user.password, false ) unless user.new_record?
        else
          password_authentication( params[:login].downcase, params[:password], false )
        end
      end
    end
  end
  #mapa
  def create_user(should_redirect = true)

    @user = current_site.users.build(params[:user])
        
    captcha_ok = validate_recap(params, @user.errors)
    
    unless params[:confirmation].nil? || params[:confirmation].empty?
      redirect_to root_url
    else
      cookies.delete :auth_token

      # @user.responsability = Responsability.find(params[:user][:responsability_id]) if params[:user][:responsability_id]
      # @user.company_size = CompanySize.find(params[:user][:company_size_id]) if params[:user][:company_size_id]
      # @user.local = Local.find(params[:user][:local_id]) if params[:user][:local_id]
    
      if @user.valid? && captcha_ok  
        @user.save 
        @user.register!
      end
      
      unless @user.new_record?
  #      redirect_back_or_default(login_path) if should_redirect
        unless @user.using_openid
          flash[:notice] = I18n.t 'txt.activation_required',
            :default => "Thanks for signing up! Please click the link in your email to activate your account"
        else
          @user.activate!
          flash[:notice] = I18n.t 'txt.signup_complete', :default => "Signup complete!"
        end
        redirect_to root_url if should_redirect
      else
        flash[:error] = @user.errors.full_messages.uniq.join(" / ")
        if should_redirect
          render :action => "new", :controller => "users"
        end
      end
      @user
    end
  end
  
  private
  def set_language
    I18n.locale = :en || I18n.default_locale
  end

end
