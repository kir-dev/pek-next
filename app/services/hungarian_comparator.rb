class HungarianComparator
  ALPHABET = Rails.configuration.x.hun_alphabet
  CHARACTER_VALUES = ALPHABET.map.with_index { |char, i| [char, i] }.to_h

  def self.compare(a_string, b_string)
    a_characters = hungarian_characters(a_string)
    b_characters = hungarian_characters(b_string)
    index = 0
    while index < a_characters.length && index < b_characters.length
      comparison_result = value(a_characters[index]) <=> value(b_characters[index])
      return comparison_result unless comparison_result.zero?

      index += 1
    end
    a_characters.length <=> b_characters.length
  end

  def self.value(character)
    CHARACTER_VALUES[character]
  end

  def self.hungarian_characters(string)
    string.downcase.split('').select { |character| CHARACTER_VALUES[character] }
  end
end
