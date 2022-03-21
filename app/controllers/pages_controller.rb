class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access

  def restrict_access
    redirect_to "/" unless current_user && current_user.user_type != 'viewer'
  end
end
