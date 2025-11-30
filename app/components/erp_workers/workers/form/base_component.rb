# frozen_string_literal: true

module ErpWorkers
  class Workers::Form::BaseComponent < ViewComponent::Base
    def initialize(account:, roles:)
      @account = account
      @roles = roles
    end
  end
end
