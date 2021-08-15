describe HungarianComparator do
  subject { proc { |a, b| HungarianComparator.compare(a, b) } }

  it 'should ignore punctuations' do
    input = ['c++', '.-B', 'A']
    expected = ['A', '.-B', 'c++']
    result = input.sort(&subject)
    expect(result).to eql(expected)
  end

  it 'should handle strings which start with identical substring' do
    input = ['alma fa', 'alma faház', 'alma']
    expected = ['alma', 'alma fa', 'alma faház']
    result = input.sort(&subject)
    expect(result).to eql(expected)
  end

  it 'should handle hungarian letters correctly' do
    input = ['Árok Part', 'Alma Fa', 'Olasz Paradicsom', 'Úr Iember','Örök Zöld', 'Uszo Da']
    expected = ['Alma Fa', 'Árok Part', 'Olasz Paradicsom', 'Örök Zöld', 'Uszo Da', 'Úr Iember']
    result = input.sort(&subject)
    expect(result).to eql(expected)
  end
end
