class NavigationList

  attr_reader :members, :letters, :first_letter

  def initialize(relation, alphabetization_field, letter)

    # Get a list of everything in the relation.
    @members = relation.order(:sort_title)

    @letters = []

    # If the first letter of an object's name/title doesn't appear in the list of
    # letters, add it.
    last_letter = ''
    @members.each do |object|
      if object.sort_title[0] != last_letter
        last_letter = object.sort_title[0]
        letters << last_letter
      end
    end

    @members = @members.select {|object| object.sort_title[0] == letter}

  end

end