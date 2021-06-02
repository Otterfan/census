class Public::ControlledNameController < ApplicationController
  layout "public"

  include Public::ControllersHelper

  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)

    @alpha_params_options = {
        bootstrap3: true,
        include_all: false,
        js: false
    }

    @navigation_list = NavigationList.new(ControlledName, :sort_name, 'A')

    @names = ControlledName.where("controlled_name LIKE :prefix", prefix: "#{@letter}%")
                 .order(:sort_name)
                 .page(params[:page])
  end

  def show
    @results_formatter = BriefResultFormatter.new([], [], [])
    @name = ControlledName.find_by('controlled_name' => params[:id])
  end
end
