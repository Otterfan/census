require 'yaml'

class VersionsController < ApplicationController
  before_action :set_version, only: [:show, :edit, :update, :destroy]

  # GET /versions
  # GET /versions.json
  def index
    @versions = PaperTrail::Version.order('created_at DESC').page(params[:page]).includes(:item)
  end

  # GET /versions/1
  # GET /versions/1.json
  def show
    @changes = YAML.load(@version.object_changes)
    @changes.delete('updated_at')
    @changed = @version.item_type.classify.constantize.find(@version.item_id)
    @changed_url = "/#{@version.item_type.downcase.pluralize}/#{@version.item_id}/edit"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_version
    @version = Version.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def version_params
    params.require(:version).permit(:item_type, :item_id, :event, :object, :created_at, :object_changes)
  end

end
