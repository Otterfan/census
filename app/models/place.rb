class Place < ApplicationRecord
  belongs_to :country, optional: true

  has_many :publication_places, inverse_of: :place, :dependent => :delete_all
  has_many :texts, :through => :publication_places, :class_name => 'Text'
  accepts_nested_attributes_for :publication_places, reject_if: :all_blank, :allow_destroy => true

  has_paper_trail

  default_scope {order(name: :asc)}

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
      puts "Place record '#{self.id}' was updated."
      start_index_process
    end
  }

end
