class PagesController < ApplicationController
  before_action :authenticate_user!

  layout'home', only: [:index]

end
