module Public::ControlledNameHelper
  def person_text_count(person)
    total_texts = person.text_count
    total_texts.to_s + " " + "text".pluralize(total_texts.to_i)
  end
end
