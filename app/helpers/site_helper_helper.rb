module SiteHelperHelper

  def in_current_path?(path_substring)
    url = request.path_info
    return request.path.start_with?("/#{path_substring}")
  end
end
