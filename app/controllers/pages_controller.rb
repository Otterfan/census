class PagesController < ApplicationController
  def index
    @comments = Comment.order(updated_at: :desc).limit(10)
    @changed_texts = Text.order(updated_at: :desc).limit(10)
  end
end
