module Admin
  module DelegatesHelper
    def delegates_warning_status(delegate_count, delegated_count)
      return 'uk-text-danger' if delegate_count < delegated_count
      return 'uk-text-warning' if delegate_count > delegated_count
    end
  end
end
