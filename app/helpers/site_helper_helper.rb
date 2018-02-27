module SiteHelperHelper
  def in_current_path?(path_substring)
    request.path.start_with?("/#{path_substring}")
  end

  def body_class
    request.path.start_with?("/public") ? 'public' : 'admin'
  end
end
