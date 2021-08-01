class JournalsController < ApplicationController
  before_action :set_journal, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /journals
  # GET /journals.json
  def index
    @journals = Journal.all.page(params[:page])
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
  end

  # GET /journals/new
  def new
    @journal = Journal.new
  end

  # GET /journals/1/edit
  def edit
    @texts = @journal.texts
  end

  # POST /journals
  # POST /journals.json
  def create
    @journal = Journal.new(journal_params)
    @journal.sort_title = journal_params[:title].sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '').sub(/^Το /, '')

    respond_to do |format|
      if @journal.save
        format.html { redirect_to edit_journal_path(@journal), notice: 'Journal was successfully created.' }
        format.json { render :show, status: :created, location: @journal }
      else
        format.html { render :new }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journals/1
  # PATCH/PUT /journals/1.json
  def update
    respond_to do |format|
      @journal.sort_title = journal_params[:title].sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '')
      @journal.save
      if @journal.update(journal_params)
        format.html { redirect_to edit_journal_path(@journal), notice: 'Journal was successfully updated.' }
        format.json { render :show, status: :ok, location: @journal }
      else
        format.html { render :edit }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.json
  def destroy
    @journal.destroy
    respond_to do |format|
      format.html { redirect_to journals_url, notice: 'Journal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_for_paper_trail
    current_user.email
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_journal
    @journal = Journal.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def journal_params
    params.require(:journal)
        .permit(:title, :sort_title, :place_id, :issn, :indexed_range,
                :sponsoring_organization, :issn_1, :issn_2, :issn_3, :eissn,
                :url, :first_published, :notes, :brief_result_note, :see_journal_id)
  end
end
