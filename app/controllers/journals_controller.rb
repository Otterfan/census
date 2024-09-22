class JournalsController < ApplicationController
  include ControllersHelper

  layout "public"

  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)
    @is_greek_letter = ('Α'..'Ω').include?(@letter)

    @alpha_params_options = {
      bootstrap3: true,
      include_all: false,
      js: false
    }

    @navigation_list = NavigationList.new(Journal, :sort_title, 'A')

    order_field = @is_greek_letter ? Arel.sql('sort_title COLLATE "el-GR-x-icu"') : :sort_title

    @journals = Journal.where("journals.sort_title LIKE :prefix", prefix: "#{@letter}%")
                       .unscope(:order)
                       .order(order_field)

    @journals = @journals.select { |journal| journal.has_visible_text }
  end

  # GET /public/journals/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@journals)
    @journal = Journal.find(params[:id])
    @referenced_texts = Text.where(:journal_id => @journal.id).where(:is_hidden => false).order(sort_date: :asc, issue_volume: :asc, issue_number: :asc, sort_page_span: :asc, sort_author: :asc)
  end

  # Go to the first author whose last name starts with
  # first_letter
  def letter
    first_journal = Journal.where.not(title: [nil, '']) # filter out nils and blanks
                           .where("sort_title LIKE ?", "#{params[:first_letter]}%")
                           .order(:sort_title)
                           .first

    redirect_to(journal_path(first_journal))
  end

end
