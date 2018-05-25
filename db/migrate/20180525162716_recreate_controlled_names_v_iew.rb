class RecreateControlledNamesVIew < ActiveRecord::Migration[5.1]
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW controlled_names AS
          SELECT DISTINCT controlled_name FROM text_citations
            WHERE controlled_name != '' AND controlled_name IS NOT NULL
          UNION SELECT DISTINCT controlled_name FROM component_citations
            WHERE controlled_name != '' AND controlled_name IS NOT NULL
          UNION SELECT DISTINCT controlled_name FROM volume_citations
            WHERE controlled_name != '' AND controlled_name != ',' AND controlled_name IS NOT NULL
;)
  end
end
