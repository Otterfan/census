module Searchable
  extend ActiveSupport::Concern


  included do

    include Elasticsearch::Model

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
                },
                synonym_file: {
                  type: :synonym,
                  synonyms_path: "synonyms.txt"
                }
            },
            analyzer: {
                english_folding: {
                    tokenizer: :standard,
                    filter: [
                        :lowercase,
                        :synonym_file,
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
          except: [
              :language_id, :topic_author_id,
              :status_id, :section_id, :country_id,
              :journal_id, :volume_id, :sort_id, :section_id,
              :sort_page_span, :sort_census_id, :seen_in_person, :sort_author,
              :sort_translator, :dai, :accessed_on, :page_count,
              # Fields below are present in the index as *_clean fields
              :physical_description, :editorial_annotation, :original, :collection, :abstract, :note,
              :original_greek_title, :original_greek_collection, :greek_source_title,
          ],
          methods: [
              :authors_names,
              :original_clean,
              :collection_clean,
              :editorial_annotation_clean,
              :abstract_clean,
              :physical_description_clean,
              :note_clean,
              :searchable_is_special_issue,
              :searchable_is_collected_volume,
              :available_online,
              :original_collections,
              :original_source,
              :translators_names,
              :editors_names,
              :performers_names,
              :is_translation,
              :publication_countries,
              :original_greek_title_clean,
              :original_greek_collection_clean,
              :greek_source_title_clean
          ],
          include: {
              text_citations: {
                  except: [:id, :created_at, :updated_at, :ordinal, :from_language_id, :to_language_id, :text_id],
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
                  except: [:id, :created_at, :updated_at, :text_id, :pages, :ordinal, :sort_pages,
                           :collection, :greek_source_title, :greek_collection_title],
                  methods: [:sort_title, :collection_clean, :greek_source_title_clean, :greek_collection_title_clean],
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
                  except: [:text_id, :place_id, :primary],
                  include: {
                      place: {
                          except: [:id, :country_id, :created_at, :updated_at]
                      }
                  }
              },
              languages: {
                  except: [:created_at, :updated_at]
              },
              urls: {
                  except: [:created_at, :updated_at, :wayback],
                  methods: [:top_level_domain]
              },
              topic_author: {
                  except: [:created_at, :updated_at, :sort_full_name, :see_person_id, :alternate_name],
                  methods: [:alternate_name_clean],
              },
              status: {
                  except: [:created_at, :updated_at, :ordinal, :code, :id, :display]
              },
              section: {
                  except: [:id, :created_at, :updated_at]
              },
              journal: {
                  except: [:created_at, :updated_at, :indexed_range, :see_journal_id, :place_id],
                  include: {
                      place: {
                          except: [:latitude, :longitude, :created_at, :updated_at],
                          include: {
                              country: {
                                  except: [:created_at, :updated_at, :al3_code, :num_code]
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
                  except: [:id, :text_id, :created_at, :updated_at]
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

  end
end