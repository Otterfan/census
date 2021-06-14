class ComponentCitation < ApplicationRecord
  include ControlledVocabulary

  belongs_to :component
  belongs_to :from_language, class_name: 'Language', foreign_key: 'from_language', optional: true
  belongs_to :to_language, class_name: 'Language', foreign_key: 'to_language', optional: true

  after_commit {
    puts "ComponentCitation record '#{self.id}' was updated. Will now update related Component record: [#{self.component.id}]"
  }

  def name=(value)
    value = prep_name(value)
    super(value)
  end

  def first_name=(value)
    value = prep_name(value)
    super(value)
  end

  def last_name=(value)
    value = prep_name(value)
    super(value)
  end

  def controlled_name=(value)
    value = prep_name(value)
    super(value)
  end

  private
  def prep_name(value)
    if value
      value.strip!
    end
    value
  end
end
