class Api < Grape::API
  prefix 'api'
  format 'json'
  mount Userm::Profile
end
