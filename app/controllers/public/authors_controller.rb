class Public::AuthorsController < ApplicationController
  layout "public"

  before_action :authenticate_user!

  def index
    @authors = Person.where(topic_flag: true).order(:full_name).page(params[:page])
  end

  def show
    @author = Person.find(params[:id])
  end
end
