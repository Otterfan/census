class RecreateControlledNameViewToAddTopicFlag < ActiveRecord::Migration[5.2]
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
SELECT DISTINCT controlled_name, sort_name, topic_flag, p.id AS person_link
FROM text_citations
         LEFT JOIN people p on TRIM(p.full_name) = text_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL
UNION
SELECT DISTINCT controlled_name, sort_name, topic_flag, p.id AS person_link
FROM component_citations
         LEFT JOIN people p on TRIM(p.full_name) = component_citations.controlled_name

WHERE controlled_name != ''
  AND controlled_name IS NOT NULL
UNION
SELECT DISTINCT controlled_name, sort_name, topic_flag, p.id AS person_link
FROM volume_citations
         LEFT JOIN people p on TRIM(p.full_name) = volume_citations.controlled_name
;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS controlled_names;"

    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
SELECT DISTINCT controlled_name, sort_name FROM text_citations
WHERE controlled_name != '' AND controlled_name IS NOT NULL
UNION SELECT DISTINCT controlled_name, sort_name FROM component_citations
WHERE controlled_name != '' AND controlled_name IS NOT NULL
UNION SELECT DISTINCT controlled_name, sort_name FROM volume_citations
;)
  end
end
