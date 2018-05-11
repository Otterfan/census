class ReindexerWorker
  include Sidekiq::Worker
  include ElasticsearchHelper

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
        index_document(@text, tid)
      else
        info_output "Text id '#{text_ids}' is not a valid ID"
      end
    end
  end
end
