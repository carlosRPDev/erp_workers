# frozen_string_literal: true

require "rails_helper"

RSpec.describe 'ErpWorkers::Workers::Form::BaseComponent', type: :component do
  let(:account) { create(:erp_core_account) }
  let(:roles) { %w[worker owner] }

  it "renders successfully with account and roles" do
    render_inline(
      described_class.new(
        account: account,
        roles: roles
      )
    )

    expect(page).to be_present
  end
end
