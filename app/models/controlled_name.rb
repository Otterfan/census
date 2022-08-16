class ControlledName < ApplicationRecord
  after_initialize :readonly!

  self.primary_key = 'controlled_name'

  def roles
    unless @roles
      text_roles = TextCitation.where(:controlled_name => self.controlled_name).pluck(:role).uniq
      comp_roles = ComponentCitation.where(:controlled_name => self.controlled_name).pluck(:role).uniq
      volume_roles = VolumeCitation.where(:controlled_name => self.controlled_name).pluck(:role).uniq
      @roles = (text_roles + comp_roles + volume_roles).uniq
    end
    @roles
  end

  def texts(role)
    texts = Text.includes(:text_citations)
                .order(sort_census_id: :asc)
                .where('texts.is_hidden' => false)
                .where('text_citations.controlled_name' => self.linking_name)
                .where('text_citations.role' => role)
    comp_texts = Text.joins(components: :component_citations)
                     .order(sort_census_id: :asc)
                     .where('texts.is_hidden' => false)
                     .where('component_citations.controlled_name' => self.linking_name)
                     .where('component_citations.role' => role)
    vol_texts = Text.joins(volume: :volume_citations)
                    .order(sort_census_id: :asc)
                    .where('texts.is_hidden' => false)
                    .where('volume_citations.controlled_name' => self.linking_name)
                    .where('volume_citations.role' => role)
    (texts + comp_texts + vol_texts).uniq
  end

  def all_texts
    texts = Text.includes(:text_citations)
                .order(sort_census_id: :asc)
                .where('texts.is_hidden' => false)
                .where('text_citations.controlled_name' => self.linking_name)
    comp_texts = Text.joins(components: :component_citations)
                     .order(sort_census_id: :asc)
                     .where('texts.is_hidden' => false)
                     .where('component_citations.controlled_name' => self.linking_name)
    vol_texts = Text.joins(volume: :volume_citations)
                    .order(sort_census_id: :asc)
                    .where('texts.is_hidden' => false)
                    .where('volume_citations.controlled_name' => self.linking_name)
    (texts + comp_texts + vol_texts).uniq
  end

  def text_count
    all_texts.count
  end

  def name_for_linking

    name_alias = self.linking_name[/.+\( *= (.*)\)/, 1]
    if name_alias
      name_alias
    else
      self.linking_name
    end
  end
end
