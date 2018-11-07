# frozen_string_literal: true

# We can sort a MembershipArray by name so monkeypatching Array class
module MembershipArray
  refine Array do
    def sort_by_name
      return self if empty?
      raise 'This method works only an array of Membership' unless
        first.is_a?(Membership) && last.is_a?(Membership)

      sort { |m1, m2| m1.user.lastname <=> m2.user.lastname }
    end
  end
end
