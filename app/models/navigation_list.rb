class NavigationList

  attr_reader :members, :letters, :first_letter

  def initialize(relation, alpha_field, letter)

    # Get a list of everything in the relation.
    @members = relation.order(alpha_field)

    @letters = []

    # If the first letter of an object's name/title doesn't appear in the list of
    # letters, add it.
    @members.each do |object|
      first_char = object[alpha_field][0, 1]
      unless letters.include?(first_char)
        letters << first_char
      end
    end

    @members = @members.select {|object| object[alpha_field][0,1] == letter}

  end

end