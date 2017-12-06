class TextsController < ApplicationController
  before_action :set_text, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  # GET /texts
  # GET /texts.json
  def index
    @texts = Text.order(:id).page(params[:page])
  end

  # GET /texts/1
  # GET /texts/1.json
  def show
    redirect_to edit_text_path(@text)
  end

  # GET /texts/new
  def new
    @text = Text.new
  end

  # GET /texts/1/edit
  def edit
    @topic_authors = []
    Person.where(topic_flag: true).each do |person|
      @topic_authors.push([person.full_name, person.id])
    end

    @journals = []
    Journal.limit(1000).each do |journal|
      @journals.push([journal.title, journal.id])
    end

    @comment = Comment.new
    @comment.text = @text

    @user = current_user
  end

  # POST /texts
  # POST /texts.json
  def create
    @text = Text.new(text_params)

    @comment = Comment.new
    @comment.text = @text

    @user = current_user

    respond_to do |format|
      if @text.save
        format.html {redirect_to @text, notice: 'Text was successfully created.'}
        format.json {render :show, status: :created, location: @text}
      else
        format.html {render :new}
        format.json {render json: @text.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /texts/1
  # PATCH/PUT /texts/1.json
  def update
    respond_to do |format|
      @comment = Comment.new
      @comment.text = @text

      @user = current_user

      if @text.update(text_params)
        format.html {redirect_to edit_text_path(@text), notice: 'Text was successfully updated.'}
        format.json {render :show, status: :ok, location: @text}
      else
        puts 'ARGH!!!'
        format.html {redirect_to edit_text_path(@text), notice: @text.errors}
        format.json {render json: @text.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /texts/1
  # DELETE /texts/1.json
  def destroy
    @text.destroy
    respond_to do |format|
      format.html {redirect_to texts_url, notice: 'Text was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def user_for_paper_trail
    current_user.email
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_text
    @text = Text.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def text_params
    params.require(:text).permit(:title, :source, :date, :publisher, :place_of_publication, :note, :original, :census_id,
                                 :parent_title, :issue_number,
                                 :issue_volume, :issue_season_month,
                                 :original_greek_title, :original_greek_publisher, :original_greek_date,
                                 :original_greek_edition, :original_greek_place_of_publication,
                                 :is_bilingual, :illustrations_noted, :format, :text_type, :material_type, :page_count,
                                 :series, :journal_title, :genre, :page_span,
                                 :url, :sponsoring_organization, :seen_in_person,
                                 :issue_title, :issue_editor, :abstract,
                                 :authors_name_from_source, :editorial_annotation,
                                 :physical_description, :original_greek_collection,
                                 :special_location_of_item, :special_source_of_info,
                                 :section_id, :status_id, :topic_author_id,
                                 :publication_places_id, :journal_id, :volume_id,
                                 publication_places_attributes: [:id, :place_id, :_destroy],
                                 text_citations_attributes: [:id, :role, :name, :from_language_id, :to_language_id, :source_edition, :_destroy],
                                 standard_numbers_attributes: [:id, :value, :_destroy],
                                 components_attributes: [:id, :title, :pages, :ordinal, :text_type,
                                                         :genre, :_destroy],
                                 other_text_languages_attributes: [:id, :language_id, :destroy]
    )
  end
end
