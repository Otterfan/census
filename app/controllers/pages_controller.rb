class PagesController < ApplicationController

  layout'public'

  def index
    @updated_texts = Text.where(is_hidden: false).order(:updated_at).last(3)
    @news = Admin::News.order(:posted_on, :id).last(1)
    render layout: 'home'
  end

  def news
    @news = Admin::News.order(:posted_on, :id).limit(2)
    render layout: 'home'
  end

end
