class Volume < ApplicationRecord
  default_scope { order(sort_title: :asc) }

  has_many :texts
  has_many :volume_citations, inverse_of: :volume, :dependent => :delete_all

  accepts_nested_attributes_for :volume_citations, reject_if: :all_blank, :allow_destroy => true

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
      puts "Volume record '#{self.id}' was updated."
      start_index_process
    end
  }

end
