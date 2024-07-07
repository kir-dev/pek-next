require 'roo'

class EvaluationXlsxParser
  attr_reader :filename, :user_count, :responsibility_count, :work_count, :principle_count

  def initialize(filename:,user_count:, responsibility_count:, work_count:)
    @filename = filename
    @user_count = user_count
    @responsibility_count = responsibility_count
    @work_count = work_count
    @principle_count = responsibility_count + work_count
  end

  def principles
    result = []
    sheet = Roo::Spreadsheet.open(filename).sheet(0)
    principle_count.times.each do |index|
      row = index + 2 # skip first line, indexing starts from 1
      result << { name: sheet.cell(row, 1),
                  max_per_member: sheet.cell(row, 2),
                      description: sheet.cell(row, 4),
                      type: index < responsibility_count ? 'RESPONSIBILITY' : 'WORK'
      }
    end
    result
  end

  def users
    result = []
    sheet = Roo::Spreadsheet.open(filename).sheet(1)
    user_count.times.each do |index|
      row = index + 2 # skip first line, indexing starts from 1
      result << sheet.cell(row, 1)
    end
    result
  end

  def points
    result = []
    sheet = Roo::Spreadsheet.open(filename).sheet(1)
    user_count.times.each do |row|
      row += 2
      point_row = []
      principle_count.times.each do |col|
        col += 2
        point_row << sheet.cell(row, col)
      end
      result << point_row
    end
    result
  end

  def comments
    result = []
    sheet = Roo::Spreadsheet.open(filename).sheet(1)
    user_count.times.each do |row|
      row += 2
      comment_row = []
      principle_count.times.each do |col|
        col += 2
        comment_row << sheet.comment(row, col)
      end
      result << comment_row
    end
    result
  end

  def results
    {principles: principles, users: users, points: points, comments: comments}
  end
end
