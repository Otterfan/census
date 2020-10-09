class Public::JournalsController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  # GET /public/journals
  def index
    redirect_to('/public/journals/letter/A')
  end

  # GET /public/journals/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@journals)
    @journal = Journal.find(params[:id])
    @referenced_texts = Text.where(:journal_id => @journal.id).order(census_id: :desc)

    # First letter of author's last name
    @first_letter = @journal.sort_title[0, 1]

    @navigation_list = NavigationList.new(Journal, :title, @first_letter)
  end

  # Go to the first author whose last name starts with
  # first_letter
  def letter
    first_journal = Journal.where.not(title: [nil, '']) # filter out nils and blanks
                       .where("sort_title LIKE ?", "#{params[:first_letter]}%")
                       .order(:sort_title)
                       .first

    redirect_to(public_journal_path(first_journal))
  end

end
