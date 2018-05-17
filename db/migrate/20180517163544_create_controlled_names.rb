class CreateControlledNames < ActiveRecord::Migration[5.1]
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
          SELECT DISTINCT controlled_name FROM text_citations
            WHERE NAME != '' AND NAME IS NOT NULL
          UNION SELECT DISTINCT controlled_name FROM component_citations
            WHERE NAME != '' AND NAME IS NOT NULL
          UNION SELECT DISTINCT controlled_name FROM volume_citations
            WHERE NAME != '' AND NAME != ',' AND NAME IS NOT NULL
;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS controlled_names;"
  end
end
