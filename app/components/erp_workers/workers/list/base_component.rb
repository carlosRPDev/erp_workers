# frozen_string_literal: true

module ErpWorkers
  class Workers::List::BaseComponent < ViewComponent::Base
    def initialize(workers:, account:)
      @workers = workers
      @account = account
    end
  end
end
