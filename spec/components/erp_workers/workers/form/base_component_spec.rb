# frozen_string_literal: true

RSpec.describe ErpWorkers::Workers::Form::BaseComponent, type: :component do
  let(:account) { create(:erp_core_account) }

  let(:roles) do
    [
      instance_double(ErpCore::Role, name: "worker"),
      instance_double(ErpCore::Role, name: "admin")
    ]
  end

  it "renders successfully with account and roles" do
    rendered = render_inline(
      described_class.new(
        account: account,
        roles: roles
      )
    )

    roles.each do |role|
      expect(rendered.to_html).to include(role.name)
    end
  end
end
