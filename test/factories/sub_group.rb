FactoryBot.define do
  factory :sub_group do
    name { 'Sub Group' }
    association(:group, factory: :group_with_parent)
  end
end