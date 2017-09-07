class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.string :name
      t.timestamps
    end
    add_reference :texts, :section, foreign_key: true

    authors = Section.new(name: 'Authors')
    authors.save
    anth_prose_poetry = Section.new( name: 'Anthology: Prose & Poetry')
    anth_prose_poetry.save
    anth_poetry = Section.new(name: 'Anthology: Poetry')
    anth_poetry.save
    anth_prose = Section.new(name: 'Anthology: Prose')
    anth_prose.save
    bibliographies = Section.new(name: 'Bibliographies')
    bibliographies.save
    lit_history = Section.new(name: 'Literary History')
    lit_history.save

    Text.update_all(section_id: authors.id)

  end
end
