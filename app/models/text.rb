require 'elasticsearch/model'

class Text < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :language, optional: true
  belongs_to :topic_author, class_name: 'Person', optional: false
  belongs_to :status
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

  after_commit() {__elasticsearch__.index_document}

  paginates_per 60

  has_paper_trail

  # these settings will create several dynamic mappings for each string-type field:
  #    keyword          : non-indexed, used for keyword searching and aggregations
  #    folded           : indexed with english stemming and asciifolding (cafe, cafes, café, cafés all match)
  #    el               : indexed with greek stemming, which includes greek stop words
  #    trim_underscores : replace underscores
  #    exact            : indexes without analyzer. provided exact token search
  settings index: {
      analysis: {
          filter: {
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
              english_possessive_stemmer: {
                  type: :stemmer,
                  language: :possessive_english
              }
          },
          analyzer: {
              folding: {
                  tokenizer: :standard,
                  filter: [
                      :english_possessive_stemmer,
                      :lowercase,
                      :english_stop,
                      :english_keywords,
                      :english_stemmer,
                      :asciifolding
                  ]
              },
              trim_underscores: {
                  tokenizer: :standard,
                  char_filter: [
                      "trim_underscores_filter"
                  ]
              },
              english_exact: {
                  tokenizer: :standard,
                  filter: [
                      :lowercase
                  ]
              }
          },
          char_filter: {
              trim_underscores_filter: {
                  type: "pattern_replace",
                  pattern: "([^_]+)?(\s?)?_?([^_]+)_?(\s?)?([^_]+)?",
                  replacement: "$1$2$3$4$5"
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
                            type: "keyword",
                            ignore_above: 256,
                        },
                        folded: {
                            type: :text,
                            analyzer: "folding"
                        },
                        el: {
                            type: :text,
                            analyzer: :greek
                        },
                        trim_underscores: {
                            type: :text,
                            analyzer: "trim_underscores"
                        },
                        exact: {
                            type: :text,
                            analyzer: "english_exact"
                        }
                    },
                    analyzer: :english
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
    as_json(
        #only: [:title, :original, :journal_title, :publisher, :place_of_publication, :authors_name_from_source, :census_id],
        except: [
            :language_id, :topic_author_id,
            :status_id, :section_id, :country_id,
            :journal_id, :volume_id, :sort_id
        ],
        methods: [:authors_names, :sort_title],
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
                        except: [:id, :country_id, :created_at, :updated_at],
                        include: {
                            country: {
                                except: [:id, :created_at, :updated_at]
                            }
                        }
                    }
                }
            },
            languages: {
                except: [:created_at, :updated_at]
            },
            topic_author: {
                except: [:created_at, :updated_at]
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
  end

  def next
    Text.where(["sort_id > ?", sort_id]).order(sort_id: :asc).first
  end

  def previous
    Text.where(["sort_id < ?", sort_id]).order(sort_id: :desc).first
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

    @authors.map(&:name).join("; ")
  end

  def translators
    unless @translators
      get_contributors
    end
    @translators
  end

  def other_contributors
    unless @other_contributors
      get_contributors
    end
    @other_contributors
  end

  def get_contributors
    @authors, @translators, @other_contributors = [], [], []
    text_citations.each do |citation|
      if citation.role == 'translator'
        @translators << citation
      elsif citation.role == 'author'
        @authors << citation
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
    @isbns ||= standard_numbers.select {|n| n.numtype = 'ISBN'}
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
    title.gsub(/["'_\[\]]/, '').sub(/^(An? )|(The )/, '')
  end

  # Pull out all unique and non-empty values for a column.
  # Only useful for fields containing a controlled vocab
  def self.get_unique_values(field_name)
    puts "running search on field: " + field_name
    Text.where.not(field_name => [nil, ""]).order(field_name => :asc).pluck(field_name).uniq
  end
end

#Text.import(force: true) # for auto sync model with elastic search
