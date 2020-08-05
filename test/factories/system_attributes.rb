# frozen_string_literal: true

FactoryBot.define do
  factory :system_attribute do
    sequence(:id, 1)
  end

  factory :system_attribute_semester, parent: :system_attribute do
    name  { 'szemeszter' }
    value { 201920101 }
  end

  factory :system_attribute_app_season, parent: :system_attribute do
    name  { 'ertekeles_idoszak' }
    value { SystemAttribute::APPLICATION_SEASON }
  end

  factory :system_attribute_max_point_for_semester, parent: :system_attribute do
    name  { 'max_point_for_semester' }
    value { 100 }
  end
end