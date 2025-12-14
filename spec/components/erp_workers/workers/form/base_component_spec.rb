# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpWorkers::Workers::Form::BaseComponent, type: :component do
  let(:account) { create(:erp_core_account) }
  let(:roles)   { create_list(:erp_core_role, 2) }

  it "renders successfully with account and roles" do
    render_inline(
      described_class.new(
        account: account,
        roles: roles
      )
    )

    roles.each do |role|
      expect(rendered_component).to include(role.name)
    end
  end
end
