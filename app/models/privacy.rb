
class 	Privacy < ActiveRecord::Base
  self.primary_key = id

  alias_attribute :attribute, :attr_name
end
