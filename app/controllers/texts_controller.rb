class TextsController < ApplicationController
  before_action :set_text, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  skip_before_action :verify_authenticity_token

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

  # POST /texts/1/original
  def update_original
    text = Text.find(params[:id])
    text.original = params[:original]
    text.save
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
                                 :series, :journal_title, :collection, :genre, :page_span,
                                 :url, :sponsoring_organization, :seen_in_person,
                                 :issue_title, :issue_editor, :abstract, :dai,
                                 :authors_name_from_source, :editorial_annotation,
                                 :physical_description, :original_greek_collection,
                                 :special_location_of_item, :special_source_of_info,
                                 :section_id, :status_id, :topic_author_id, :original,
                                 :publication_places_id, :journal_id, :volume_id,
                                 publication_places_attributes: [:id, :place_id, :primary, :_destroy],
                                 text_citations_attributes: [:id, :role, :name, :first_name, :last_name, :from_language_id, :to_language_id, :source_edition, :_destroy],
                                 standard_numbers_attributes: [:id, :value, :_destroy],
                                 components_attributes: [:id, :title, :pages, :note, :ordinal, :text_type,
                                                         :genre, :is_bilingual, :_destroy,
                                                         component_citations_attributes: [:id, :name, :role, :first_name, :last_name, :from_language_id, :to_language_id]
                                 ],
                                 component_citations_attributes: [:id, :name, :role, :first_name, :last_name, :_destroy],
                                 other_text_languages_attributes: [:id, :language_id, :destroy],
                                 cross_references_attributes: [:id, :census_id, :destroy]

    )
  end
end
