module ElasticsearchHelper

  def info_output(message)
    logger.info message
    puts message
  end

  def error_output(message)
    logger.error message
    puts message
  end

  def index_document(record, record_id)
    begin
      info_output "Reindexing Text record id '#{record_id}'"
      record.__elasticsearch__.index_document
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      error_output "Elasticsearch NotFound Error: #{e}"
    rescue Elasticsearch::Transport::Transport::ServerError => e
      error_output "Elasticsearch ServerError: #{e}"
    rescue Elasticsearch::Transport::Transport::Error => e
      error_output "Elasticsearch Transport Error: #{e}"
    rescue StandardError => e
      error_output "Rails StandardError: #{e}"
    end
  end

end