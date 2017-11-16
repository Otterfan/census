class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = Comment.order(updated_at: :desc).limit(10)
    @changed_texts = Text.order(updated_at: :desc).limit(10)
  end
end
