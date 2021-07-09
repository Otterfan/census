class Public::ControlledNameController < ApplicationController
  layout "public"

  include Public::ControllersHelper

  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)
    @is_greek_letter = ('Α'..'Ω').include?(@letter)

    @alpha_params_options = {
        bootstrap3: true,
        include_all: false,
        js: false
    }

    @navigation_list = NavigationList.new(ControlledName, :sort_name, 'A')

    order_field = @is_greek_letter ? 'sort_name COLLATE "el-GR-x-icu"' : :sort_name

    @names = ControlledName.where("controlled_name LIKE :prefix", prefix: "#{@letter}%")
                 .unscope(:order)
                 .order(order_field)
                 .page(params[:page])
  end

  def show
    @results_formatter = BriefResultFormatter.new([], [], [])
    @name = ControlledName.find_by('controlled_name' => params[:id])
    @in_text = TextCitation.where(:controlled_name => params[:id]).pluck(:name)
  end
end
