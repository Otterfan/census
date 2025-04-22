class AddIsPublishedToControlledNames < ActiveRecord::Migration[6.1]
  def up
    self.connection.execute "DROP VIEW IF EXISTS controlled_names;"

    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
SELECT DISTINCT controlled_name, controlled_name as linking_name, sort_name, topic_flag, p.id AS person_link
FROM text_citations
         LEFT JOIN people p on TRIM(p.full_name) = text_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL
  AND p.published = true

UNION
SELECT DISTINCT controlled_name, controlled_name as linking_name, sort_name, topic_flag, p.id AS person_link
FROM component_citations
         LEFT JOIN people p on TRIM(p.full_name) = component_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL
  AND p.published = true

UNION
SELECT DISTINCT controlled_name, controlled_name as linking_name, sort_name, topic_flag, p.id AS person_link
FROM volume_citations
         LEFT JOIN people p on TRIM(p.full_name) = volume_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL
  AND p.published = true

UNION
SELECT DISTINCT greek_full_name, full_name as linking_name, greek_full_name, topic_flag, id AS person_link
FROM people
WHERE topic_flag IS true
  AND greek_full_name IS NOT NULL
  AND greek_full_name != ''
  AND published = true
;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS controlled_names;"

    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
SELECT DISTINCT controlled_name, controlled_name as linking_name, sort_name, topic_flag, p.id AS person_link
FROM text_citations
         LEFT JOIN people p on TRIM(p.full_name) = text_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL

UNION
SELECT DISTINCT controlled_name, controlled_name as linking_name, sort_name, topic_flag, p.id AS person_link
FROM component_citations
         LEFT JOIN people p on TRIM(p.full_name) = component_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL

UNION
SELECT DISTINCT controlled_name, controlled_name as linking_name, sort_name, topic_flag, p.id AS person_link
FROM volume_citations
         LEFT JOIN people p on TRIM(p.full_name) = volume_citations.controlled_name
WHERE controlled_name != ''
  AND controlled_name IS NOT NULL

UNION
SELECT DISTINCT greek_full_name, full_name as linking_name, greek_full_name, topic_flag, id AS person_link
FROM people
WHERE topic_flag IS true
  AND greek_full_name IS NOT NULL
  AND greek_full_name != ''
;)
  end
end
