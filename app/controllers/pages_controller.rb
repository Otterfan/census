class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access

  layout'home', only: [:index]

  def restrict_access
    redirect_to "/" unless current_user && current_user.user_type != 'viewer'
  end
end
