class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :streams_list
  before_filter :check_first_use

  private
    def streams_list
      @streams = RssStream.order("UPPER(title) ASC")
    end

    def check_first_use
      num_users = User.all.count
      redirect_to new_user_registration_url if num_users == 0
    end
end
