class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_first_use
  before_filter :authenticate_user!
  before_filter :streams_list

  private
    def streams_list
      @streams = RssStream.order("UPPER(title) ASC")
    end

    def check_first_use
      if params[:action] != 'new' && params[:controller] != 'devise/sessions'
        num_users = User.all.count
        redirect_to new_user_registration_url if num_users == 0
      end
    end
end
