json.array! @columns do |column|
  json.title column[:title]
  json.field column[:field]
end
