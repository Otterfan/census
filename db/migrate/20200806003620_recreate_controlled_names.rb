class RecreateControlledNames < ActiveRecord::Migration[5.2]
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
SELECT DISTINCT controlled_name, sort_name FROM text_citations
WHERE controlled_name != '' AND controlled_name IS NOT NULL
UNION SELECT DISTINCT controlled_name, sort_name FROM component_citations
WHERE controlled_name != '' AND controlled_name IS NOT NULL
UNION SELECT DISTINCT controlled_name, sort_name FROM volume_citations
;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS controlled_names;"
  end
end
