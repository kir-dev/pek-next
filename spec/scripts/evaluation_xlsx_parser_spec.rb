require 'rails_helper'
require './scripts/evaluation_xlsx_parser'

RSpec.describe EvaluationXlsxParser do
  subject(:parser) { EvaluationXlsxParser.new(filename: './spec/scripts/test_evaluation.xlsx', user_count: 4,
                                              responsibility_count: 2, work_count: 2) }

  it 'reads the principles' do
    principles = parser.principles

    expect(principles[0]).to include(name: "Körvezető", type: "RESPONSIBILITY", max_per_member: 20,
                                     description: "Körvezető felelőssége.")
    expect(principles[1]).to include(name: "Gazdaságis", type: "RESPONSIBILITY", max_per_member: 15,
                                     description: "A kör gazdasági ügyeit intézte.")
    expect(principles[2]).to include(name: "Projekt munka", type: "WORK", max_per_member: 30,
                                     description: "A kör projekjein végzett munka.")
    expect(principles[3]).to include(name: "Tanfolyam tartás", type: "WORK", max_per_member: 15,
                                     description: "A kör tanfolyamainak megtartása.")
  end

  it 'reads users' do
    users = parser.users

    expect(users).to be_eql(["Körvezető Károly", "Gazdaságis Géza", "Projekező Pál", "Tanfolyam Tibor"])
  end

  it 'reads points' do
    points = parser.points

    expect(points).to be_eql([[20, 5, 30, 15],
                              [nil, 15, 20, 5],
                              [nil, nil, 40, nil],
                              [nil, nil, 20, 15]])
  end

  it 'reads comments' do
    comments = parser.comments

    expect(comments).to be_eql([["Vezette a kört", "Számlákat kezelte", "Sok projekten dolgozott", "5 tanfolyam alklamat tartott"],
                                        [nil, "Kezelte a gazdaságis ügyeket", "Projektezett sokat", "1 tanfolyam alkalom"],
                                        [nil, nil, "Mindent feladatot is megcsinált", nil],
                                        [nil, nil, "Sokat dolgozott", "Megtartott 5 tanfolyamalkalmat"]])
  end

  it 'has results' do
    results = parser.results

    expect(results).to be_present
  end
end
