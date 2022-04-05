class PagesController < ApplicationController

  layout'public'

  def index
    render layout: 'home'
  end

end
