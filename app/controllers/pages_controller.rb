class PagesController < ApplicationController
  before_action :authenticate_user!

  layout'public'

  def index
    render layout: 'home'
  end

end
