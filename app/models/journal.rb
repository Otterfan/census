class Journal < ApplicationRecord
  belongs_to :place, optional: true
  has_many :texts
  default_scope { order(sort_title: :asc) }

  has_paper_trail

  def get_associated_texts_ids
    self.texts.pluck(:id)
  end

  def start_index_process
    ids = get_associated_texts_ids
    puts "Will now trigger reindexing for the following #{ids.length} related Text record(s): #{ids}"
    ReindexerWorker.perform_async(ids)
  end

  @should_reindex = false

  before_save {
    if self.changes.present?
      @should_reindex = true
    end
  }

  after_commit {
    if @should_reindex
      puts "Journal record '#{self.id}' was updated."
      start_index_process
    end
  }

end
