class RemoveSpacesFromCensusIDs < ActiveRecord::Migration[5.1]
  def up
    text = Text.find(1231)
    text.census_id = '4.752'
    text.sort_census_id = '04000752'
    text.save
  end
end
