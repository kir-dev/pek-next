json.array! @columns do |column|
  column.each do |key, value|
    json.set! key, value
  end
end
