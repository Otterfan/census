class VolumesController < ApplicationController
  before_action :set_volume, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /volumes
  # GET /volumes.json
  def index
    @volumes = Volume.all.page(params[:page])
  end

  # GET /volumes/1
  # GET /volumes/1.json
  def show
  end

  # GET /volumes/new
  def new
    @volume = Volume.new
  end

  # GET /volumes/1/edit
  def edit
    @texts = @volume.texts
  end

  # POST /volumes
  # POST /volumes.json
  def create
    @volume = Volume.new(volume_params)
    @volume.sort_title = volume_params[:title].sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '').sub(/:/, '')

    respond_to do |format|
      if @volume.save
        format.html {redirect_to edit_volume_path(@volume), notice: 'Volume was successfully created.'}
        format.json {render :show, status: :created, location: @volume}
      else
        format.html {render :new}
        format.json {render json: @volume.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /volumes/1
  # PATCH/PUT /volumes/1.json
  def update
    respond_to do |format|
      @volume.sort_title = volume_params[:title].sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '').sub(/:/, '')
      @volume.save

      if @volume.update(volume_params)
        format.html {redirect_to edit_volume_path(@volume), notice: 'Volume was successfully updated.'}
        format.json {render :show, status: :ok, location: @volume}
      else
        format.html {render :edit}
        format.json {render json: @volume.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /volumes/1
  # DELETE /volumes/1.json
  def destroy
    @volume.destroy
    respond_to do |format|
      format.html {redirect_to volumes_url, notice: 'Volume was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def user_for_paper_trail
    current_user.email
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_volume
    @volume = Volume.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def volume_params
    params.require(:volume).permit(
        :title, :sort_title, :author, :location_id, :date, :brief_result_note,
        # @TODO fix the from_language_id_id problem
        volume_citations_attributes: [:id, :role, :last_name, :first_name, :controlled_name, :from_language_id_id, :to_language_id_id, :source_edition,:_destroy],
    )
  end
end
