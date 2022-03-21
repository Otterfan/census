class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access

  def restrict_access
    redirect_to "/" unless current_user && current_user.user_type != 'viewer'
  end

  def index
    @comments = Comment.order(updated_at: :desc).limit(10)
    @changed_texts = PaperTrail::Version.where("item_type = 'Text'").order(:created_at => :desc).limit(10).includes(:item)
  end

end
