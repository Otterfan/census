require 'elasticsearch/model'
require 'htmlentities'

class Text < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include SharedMethods

  belongs_to :language, optional: true
  belongs_to :topic_author, class_name: 'Person', optional: true
  belongs_to :status, optional: true
  belongs_to :volume, optional: true
  belongs_to :section, optional: true
  belongs_to :journal, optional: true
  has_many :text_citations, inverse_of: :text, :dependent => :delete_all
  has_many :standard_numbers, inverse_of: :text, :dependent => :delete_all
  has_many :components, inverse_of: :text, :dependent => :delete_all
  has_many :comments, inverse_of: :text, :dependent => :delete_all
  has_many :cross_references, inverse_of: :text, :dependent => :delete_all

  has_many :other_text_languages, inverse_of: :text, :dependent => :delete_all
  has_many :languages, :through => :other_text_languages, :class_name => 'Language'

  has_many :publication_places, inverse_of: :text, :dependent => :delete_all
  has_many :places, :through => :publication_places, :class_name => 'Place'

  accepts_nested_attributes_for :text_citations, :standard_numbers, :components, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :other_text_languages, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :publication_places, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :cross_references, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :components, reject_if: :all_blank, :allow_destroy => true

  before_save :default_values
  before_save :calculate_sort_census_id
  before_save :calculate_sort_page_span
  before_save :calculate_sort_date

  after_touch {
    puts "Text record '#{self.id}' was touched."
    #__elasticsearch__.index_document
  }

  after_commit {
    puts "Text record '#{self.id}' was updated. Will now reindex."
    __elasticsearch__.index_document
  }

  paginates_per 60

  has_paper_trail

  # these settings will create several dynamic mappings for each string-type field:
  #    keyword          : non-indexed, used for keyword searching and aggregations
  #    en               : indexed with default english filters:
  #                       [english_possessive_stemmer, lowercase, english_stop, english_keywords, english_stemmer]
  #    en_folded        : indexed with english lowercase, stop words and asciifolding (cafe & café both match)
  #    el               : indexed with default greek filters:
  #                       [greek_lowercase, greek_stop, greek_keywords, greek_stemmer]
  #    el_folded        : indexed with greek lowercase, greek stop words and uses ICU plugin for Unicode languages. provides folding for greek letters
  #    exact            : indexes with lowercase but without using an analyzer. provided exact token search
  settings index: {
      analysis: {
          filter: {
              english_possessive_stemmer: {
                  type: :stemmer,
                  language: :possessive_english
              },
              english_stop: {
                  type: :stop,
                  stopwords: "_english_"
              },
              english_keywords: {
                  type: :keyword_marker,
                  keywords: [:example]
              },
              english_stemmer: {
                  type: :stemmer,
                  language: :english
              },
              greek_lowercase: {
                  type: :lowercase,
                  language: :greek
              },
              greek_stop: {
                  type: :stop,
                  stopwords: "_greek_"
              },
              greek_keywords: {
                  type: :keyword_marker,
                  keywords: ["παράδειγμα"]
              },
              greek_stemmer: {
                  type: :stemmer,
                  language: :greek
              }
          },
          analyzer: {
              english_folding: {
                  tokenizer: :standard,
                  filter: [
                      :lowercase,
                      :english_possessive_stemmer,
                      :english_stop,
                      :asciifolding
                  ]
              },
              greek_folding: {
                  tokenizer: :icu_tokenizer,
                  filter: [
                      :greek_lowercase,
                      :greek_stop,
                      :icu_folding
                  ]
              },
              exact: {
                  tokenizer: :keyword,
                  filter: [
                      :lowercase
                  ]
              }
          }
      }
  } do
    mapping dynamic_templates: [
        {
            strings: {
                match_mapping_type: :string,
                mapping: {
                    fields: {
                        keyword: {
                            type: :keyword,
                            ignore_above: 256,
                        },
                        en: {
                            type: :text,
                            analyzer: :english
                        },
                        en_folded: {
                            type: :text,
                            term_vector: :with_positions_offsets,
                            analyzer: :english_folding
                        },
                        el: {
                            type: :text,
                            analyzer: :greek
                        },
                        el_folded: {
                            type: :text,
                            term_vector: :with_positions_offsets,
                            analyzer: :greek_folding
                        },
                        exact: {
                            type: :text,
                            analyzer: :exact
                        }
                    },
                    analyzer: :standard,
                    term_vector: :with_positions_offsets
                }
            },
        },
        {
            integer_fields: {
                mapping: {
                    fields: {
                        raw: {
                            type: :integer,
                            index: "not_analyzed"
                        }
                    }
                },
                match: "id",
                match_mapping_type: "string"
            }
        },
        {
            integer_fields: {
                mapping: {
                    fields: {
                        raw: {
                            index: "not_analyzed"
                        }
                    }
                },
                match: "authors_names",
                match_mapping_type: "string"
            }
        }
    ]
  end


  def as_indexed_json(options = {})
    json_to_index = as_json(
        #only: [:title, :original, :journal_title, :publisher, :place_of_publication, :authors_name_from_source, :census_id],
        except: [
            :language_id, :topic_author_id,
            :status_id, :section_id, :country_id,
            :journal_id, :volume_id, :sort_id
        ],
        methods: [
            :authors_names,
            :sort_title,
            :original_clean,
            :collection_clean,
            :editorial_annotation_clean,
            :abstract_clean,
            :physical_description_clean,
            :note_clean,
            :searchable_is_special_issue,
            :searchable_is_collected_volume,
            :available_online
        ],
        include: {
            text_citations: {
                except: [:created_at, :updated_at, :from_language_id, :to_language_id],
                include: {
                    from_language: {
                        except: [:created_at, :updated_at]
                    },
                    to_language: {
                        except: [:created_at, :updated_at]
                    }
                }
            },
            components: {
                except: [:created_at, :updated_at],
                methods: [:sort_title, :collection_clean],
                include: {
                    component_citations: {
                        except: [:id, :component_id, :from_language_id, :to_language_id, :created_at, :updated_at],
                        include: {
                            from_language: {
                                except: [:id, :created_at, :updated_at]
                            },
                            to_language: {
                                except: [:id, :created_at, :updated_at]
                            }
                        }
                    }
                }
            },
            publication_places: {
                except: [:text_id],
                include: {
                    place: {
                        except: [:id, :country_id, :created_at, :updated_at]
                    }
                }
            },
            languages: {
                except: [:created_at, :updated_at]
            },
            topic_author: {
                except: [:created_at, :updated_at],
                methods: [:alternate_name_clean],
            },
            status: {
                except: [:created_at, :updated_at]
            },
            section: {
                except: [:created_at, :updated_at]
            },
            # can't get this table to get indexed
            #country: {
            #    except: [:id, :created_at, :updated_at]
            #},
            journal: {
                except: [:created_at, :updated_at],
                include: {
                    place: {
                        except: [:created_at, :updated_at],
                        include: {
                            country: {
                                except: [:created_at, :updated_at]
                            }
                        }
                    }
                }
            },
            volume: {
                except: [:created_at, :updated_at],
                include: {
                    volume_citations: {
                        except: [:volume_id, :from_language_id_id, :to_language_id_id, :created_at, :updated_at],
                        include: {
                            from_language: {
                                except: [:created_at, :updated_at]
                            },
                            to_language: {
                                except: [:created_at, :updated_at]
                            }
                        }
                    }
                }
            },
            standard_numbers: {
                except: [:text_id, :created_at, :updated_at]
            },
            other_text_languages: {
                except: [],
                include: {
                    language: {
                        except: [:created_at, :updated_at]
                    }
                }
            },
            cross_references: {
                except: [:created_at, :updated_at]
            }

        }
    )

    # Split pipe delimited genres (e.g. "Poetry | Prose") into
    # individual components.
    if json_to_index.key?("genre") && !json_to_index["genre"].nil?
      json_to_index["genre"] = json_to_index["genre"].split(" | ")
    end
    json_to_index
  end

  def next
    if sort_census_id.empty?
      Text.where(["id > ?", id]).order(id: :asc).first
    else
      Text.where(["sort_census_id > ?", sort_census_id]).order(sort_census_id: :asc).first
    end
  end

  def previous
    if sort_census_id.empty?
      Text.where(["id < ?", id]).order(id: :desc).first
    else
      Text.where(["sort_census_id < ?", sort_census_id]).order(sort_census_id: :desc).first
    end
  end

  def authors
    unless @authors
      get_contributors
    end

    if text_type.respond_to?(:starts_with?) && text_type.starts_with?('translat')
      author_citation = TextCitation.new
      author_citation.name = topic_author.full_name
      @authors = [author_citation]
    end

    @authors
  end

  def authors_names
    unless @authors
      get_contributors
    end

    authors_names = @authors.map.map(&:name)
    translators_names = @translators.map { |person| person.name + ' (tr.)' }
    named_contributors = authors_names + translators_names
    named_contributors.join('; ')
  end

  def translators
    unless @translators
      get_contributors
    end
    @translators
  end

  def translators_names
    translators_names = self.translators.map { |person| person.name + ' (tr.)' }
    translators_names.join('; ')
  end

  def editors
    unless @editors
      get_contributors
    end
    @editors
  end

  def editors_names
    editors_names = self.editors.map { |person| person.name + ' (ed.)' }
    editors_names.join('; ')
  end

  def other_contributors
    unless @other_contributors
      get_contributors
    end
    @other_contributors
  end

  def get_contributors
    @authors, @translators, @editors, @other_contributors = [], [], [], []
    text_citations.each do |citation|
      if citation.role == 'translator'
        @translators << citation
      elsif citation.role == 'author'
        @authors << citation
      elsif citation.role == 'editor'
        @editors << citation
      else
        @other_contributors << citation
      end
    end
  end

  def poems
    unless @poems
      get_components
    end
    puts @poems
    @poems
  end

  def stories
    unless @stories
      get_components
    end
    @stories
  end

  def isbns
    @isbns ||= standard_numbers.select { |n| n.numtype = 'ISBN' }
  end

  def other_components
    unless @other_components
      get_components
    end
    @other_components
  end

  def get_components
    @poems, @stories, @other_components = [], [], []
    components.each do |component|
      if component.genre == 'Poetry'
        @poems << component
      elsif component.genre == 'Short story'
        @stories << component
      else
        @other_components << component
      end
    end
  end

  def formatted_original
    if original.include? '<p>'
      markdown
    end
  end

  def sort_title
    title.gsub(/["'“”‘’«»:_.\[\]]/, '').sub(/^(An? )|(The )/, '').strip
  end

  def original_clean
    if original
      # duplicate the original field for our transformations
      @cleaned_original = original.dup

      # apply clean_field method
      clean_field @cleaned_original
    else
      nil
    end
  end

  def collection_clean
    if collection
      # duplicate the original field for our transformations
      @cleaned_collection = collection.dup

      # apply clean_field method
      clean_field @cleaned_collection
    else
      nil
    end
  end

  def editorial_annotation_clean
    if editorial_annotation
      # duplicate the original field for our transformations
      @cleaned_editorial_annotation = editorial_annotation.dup

      # apply clean_field method
      clean_field @cleaned_editorial_annotation
    else
      nil
    end
  end

  def abstract_clean
    if abstract
      # duplicate the original field for our transformations
      @cleaned_abstract = abstract.dup

      # apply clean_field method
      clean_field @cleaned_abstract
    else
      nil
    end
  end

  def physical_description_clean
    if physical_description
      # duplicate the original field for our transformations
      @cleaned_physical_description = physical_description.dup

      # apply clean_field method
      clean_field @cleaned_physical_description
    else
      nil
    end
  end

  def note_clean
    if note
      # duplicate the original field for our transformations
      @cleaned_note = note.dup

      # apply clean_field method
      clean_field @cleaned_note
    else
      nil
    end
  end

  # Pull out all unique and non-empty values for a column.
  # Only useful for fields containing a controlled vocab
  def self.get_unique_values(field_name)
    puts "running search on field: " + field_name
    Text.where.not(field_name => [nil, ""]).order(field_name => :asc).pluck(field_name).uniq
  end

  # Default values for blank fields
  def default_values

    # Set publication place to journal pub place if blank
    if self.publication_places.empty? && self.journal && self.journal.place
      pub_place = PublicationPlace.new
      pub_place.place = self.journal.place
      pub_place.text = self
      self.publication_places << pub_place
    end
  end

  def calculate_sort_census_id
    if self.census_id.blank?
      self.sort_census_id = ''
      return
    end

    section_id, text_id = self.census_id.split('.')

    text_major, text_minor = text_id.split('-')

    text_minor ||= 0

    major = section_id.to_s.rjust(2, "0")
    text_major = text_major.to_s.rjust(6, "0")
    text_minor = text_minor.to_s.rjust(6, "0")

    self.sort_census_id = major + text_major + text_minor
  end

  def calculate_sort_page_span()
    if self.page_span
      matches = self.page_span.match /\D*(\d+)/
      unless matches.nil?
        self.sort_page_span = matches[1].to_i
      end
    end
  end

  def calculate_sort_date
    unless self.date.nil?
      sort_date = self.date[/\d\d\d\d/]
      self.sort_date = "#{sort_date}-01-01"
    end
  end

  def original_greek_citation
    citation = nil

    has_title = !original_greek_title.nil? && !original_greek_title.empty?
    has_publisher = !original_greek_publisher.nil? && !original_greek_publisher.empty?
    has_date = !original_greek_date.nil? && !original_greek_date.empty?
    has_place = !original_greek_place_of_publication.nil? && !original_greek_place_of_publication.empty?

    if has_title && has_publisher && has_place && has_date
      citation = "#{original_greek_title} (#{original_greek_place_of_publication}: #{original_greek_publisher}, #{original_greek_date})"
    elsif has_title && has_publisher && has_date
      citation = "#{original_greek_title} (#{original_greek_publisher}, #{original_greek_date})"
    elsif has_title && has_publisher
      citation = "#{original_greek_title} (#{original_greek_publisher})"
    elsif has_title && has_date
      citation = "#{original_greek_title} (#{original_greek_date})"
    elsif has_title && has_place
      citation = "#{original_greek_title} (#{original_greek_place_of_publication})"
    elsif has_title
      citation = original_greek_title
    end

    citation
  end

  def display_text_type
    if text_type === 'translation_part'
      'Translation (part)'
    elsif text_type === 'translation_book'
      'Translation (volume)'
    elsif text_type === 'study_part'
      'Study (part)'
    else
      'Study (volume)'
    end
  end

  def plural_display_text_type
    if text_type === 'translation_part'
      'Translations (part)'
    elsif text_type === 'translation_book'
      'Translations (volume)'
    elsif text_type === 'study_part'
      'Studies (part)'
    else
      'Studies (volume)'
    end
  end

  def display_page_span
    page_mark = page_span.include?('-') || page_span.include?(',') ? 'pp' : 'p'
    page_mark + '. ' + page_span
  end

  def searchable_is_special_issue
    is_special_issue ? 'special issue' : ''
  end

  def searchable_is_collected_volume
    is_collected_volume ? 'collected volume' : ''
  end

  def available_online
    if url.nil?
      return ''
    end
    url.include?('http') ? 'available online' : ''
  end

  # Returns a message if the Census ID is invalid
  def census_id_evaluation
    if /\A\d\./.match(census_id).nil?
      "Census ID must start with a digit"
    end
  end

end

#Text.import(force: true) # for auto sync model with elastic search
