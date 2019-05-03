FactoryBot.define do
  factory :group do
    name { 'Babhámozó' }
    type { 'szakmai kör' }

    trait :with_additional_info do
      description { 'vietnámiak' }
      webpage { 'http://babhamozo.sch.bme.hu' }
      maillist { 'babhamozo@sch.bme.hu' }
      founded { 1998 }
    end
  end
end
