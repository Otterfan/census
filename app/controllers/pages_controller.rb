class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = Comment.order(updated_at: :desc).limit(10)
    @changed_texts = PaperTrail::Version.where("item_type = 'Text'").order(:created_at => :desc).limit(10).includes(:item)
  end
end
