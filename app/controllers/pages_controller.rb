class PagesController < ApplicationController
  def index
    @comments = Comment.limit(10).order('id DESC')
    @changed_texts = Text.limit(10).order('updated_at DESC')
  end
end
