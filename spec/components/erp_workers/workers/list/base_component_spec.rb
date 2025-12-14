# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpWorkers::Workers::List::BaseComponent, type: :component do
  let(:account) { create(:erp_core_account) }
  let(:workers) { create_list(:erp_core_user, 2) }

  it "renders successfully with workers and account" do
    render_inline(
      described_class.new(
        workers: workers,
        account: account
      )
    )

    expect(page).to be_present
  end
end
