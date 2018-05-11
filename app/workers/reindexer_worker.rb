class ReindexerWorker
  include Sidekiq::Worker

  def info_output(message)
    logger.info message
    puts message
  end

  def error_output(message)
    logger.error message
    puts message
  end

  def perform(text_ids)
    info_output "\nReceived list of text ids: #{text_ids}"

    text_ids.each do |tid|
      if tid.is_a? Integer
        # instantiate Text record by given ID
        begin
          @text = Text.find_by(id: tid)
        rescue ActiveRecord::RecordNotFound => e
          error_output "RecordNotFound: Could not find Text record id ##{tid}: #{e}"
          next
        rescue StandardError => e
          error_output "StandardError: Could not find Text record id ##{tid}: #{e}"
          next
        end

        # attempt to index Text record
        begin
          info_output "Reindexing Text record id '#{tid}'"
          @text.__elasticsearch__.index_document
        rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
          error_output "Elasticsearch NotFound Error: #{e}"
        rescue Elasticsearch::Transport::Transport::ServerError => e
          error_output "Elasticsearch ServerError: #{e}"
        rescue Elasticsearch::Transport::Transport::Error => e
          error_output "Elasticsearch Transport Error: #{e}"
        rescue StandardError => e
          error_output "Rails StandardError: #{e}"
        end
      else
        info_output "Text id '#{text_ids}' is not a valid ID"
      end
    end
  end
end
