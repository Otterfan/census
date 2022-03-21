class Admin::PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :restrict_access

  def restrict_access
    redirect_to "/" unless current_user && current_user.user_type != 'viewer'
  end

  # GET /people
  # GET /people.json
  def index
    @people = Person.where(topic_flag: true).order(:full_name).page(params[:page])
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
    @texts = @person.texts
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    @person.topic_flag = true

    respond_to do |format|
      if @person.save
        format.html {redirect_to edit_admin_person_path(@person), notice: 'Person was successfully created.'}
        format.json {render :show, status: :created, location: @person}
      else
        format.html {render :new}
        format.json {render json: @person.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html {render :edit, notice: 'Person was successfully updated.'}
        format.json {render :show, status: :ok, location: @person}
      else
        format.html {render :edit}
        format.json {render json: @person.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html {redirect_to edit_admin_person_path(@person), notice: 'Person was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def user_for_paper_trail
    current_user.email
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(:person).permit(:full_name, :greek_full_name, :first_name, :last_name, :birth, :death,
                                   :greek_first_name, :greek_last_name, :alternate_name, :domicile,
                                   :viaf, :loc, :greek_authority, :loc_name, :see_person_id)
  end
end
