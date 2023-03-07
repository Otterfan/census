json.extract! admin_news, :id, :brief_content, :content, :note, :posted_on, :created_at, :updated_at
json.url admin_news_url(admin_news, format: :json)
