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

    @names, @alpha_params = ControlledName.order(:controlled_name)
                                .alpha_paginate(@letter, @alpha_params_options) {|name| name.controlled_name}
  end

  def show
    @results_formatter = BriefResultFormatter.new([], [], [])
    @name = ControlledName.find_by('controlled_name' => params[:id])
  end
end
