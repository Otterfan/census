class PagesController < ApplicationController

  layout'public'

  def index
    @updated_texts = Text.where(is_hidden: false).order(:updated_at).last(3)
    @news = Admin::News.where('published = true AND posted_on <= ?', Date.today).order(:posted_on, :id).last(3)
    render layout: 'home'
  end

  def news
    @news = Admin::News.order(:posted_on, :id).limit(2)
  end

end
