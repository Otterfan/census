require 'elasticsearch/model'

class Text < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :language, optional: true
  belongs_to :topic_author, class_name: 'Person', optional: true
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

  accepts_nested_attributes_for :text_citations, :standard_numbers, :components , reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :other_text_languages, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :publication_places, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :cross_references, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :components,  reject_if: :all_blank, :allow_destroy => true

  paginates_per 60

  has_paper_trail

=begin
  settings do
    mappings dynamic: false do
      indexes :title, type: :text, analyzer: :english
      indexes :original, type: :text, analyzer: :english
      indexes :journal_title, type: :text, analyzer: :english
      indexes :publisher, type: :text, analyzer: :english
      indexes :place_of_publication, type: :text, analyzer: :english
      indexes :authors_name_from_source, type: :text
      indexes :census_id, type: :text
      indexes :id, type: :text
    end
  end
=end

  def as_indexed_json(options={})
    as_json(
        #only: [:title, :original, :journal_title, :publisher, :place_of_publication, :authors_name_from_source, :census_id],
        except: [
            :sort_date, :language_id, :topic_author_id,
            :status_id, :section_id, :country_id, :journal_id,
            :volume_id, :sort_id
        ],
        include: {
            text_citations: {
                except: [:id, :text_id, :created_at, :updated_at, :from_language_id, :to_language_id],
                include: {
                    from_language: {
                        except: [:id, :created_at, :updated_at]
                    },
                    to_language: {
                        except: [:id, :created_at, :updated_at]
                    }
                }
            },
            components: {
                except: [:id, :text_id, :created_at, :updated_at],
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
                except: [:id, :place_id, :text_id],
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
                except: [:id, :created_at, :updated_at]
            },
            topic_author: {
                except: [:id, :created_at, :updated_at]
            },
            status: {
                except: [:id, :created_at, :updated_at]
            },
            section: {
                except: [:id, :created_at, :updated_at]
            },
            # can't get this table to get indexed
            #country: {
            #    except: [:id, :created_at, :updated_at]
            #},
            journal: {
                except: [:id, :place_id, :created_at, :updated_at],
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
            volume: {
                except: [:id, :created_at, :updated_at],
                include: {
                  volume_citations: {
                      except: [:id, :volume_id, :from_language_id_id, :to_language_id_id, :created_at, :updated_at],
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
            standard_numbers: {
                except: [:id, :text_id, :created_at, :updated_at]
            },
            other_text_languages: {
                except: [:id, :language_id],
                include: {
                    language: {
                        except: [:id, :created_at, :updated_at]
                    }
                }
            },
            cross_references: {
                except: [:id, :text_id, :created_at, :updated_at],
                include: {
                    text: {
                        only: [:title, :date],
                        include: {
                            topic_author: {
                                only: [:full_name, :birth, :death, :viaf, :loc]
                            }
                        }
                    }
                }
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

  def formatted_original
    if original.include? '<p>'
      markdown
    end
  end
end

#Text.import(force: true) # for auto sync model with elastic search
