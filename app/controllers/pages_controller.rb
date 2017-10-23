class PagesController < ApplicationController
  def index
    @comments = Comment.limit(10).order('id DESC').reverse
  end
end
