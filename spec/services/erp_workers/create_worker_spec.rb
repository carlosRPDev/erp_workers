# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpWorkers::CreateWorker do
  let(:account) { create(:erp_core_account) }
  let(:inviter) { create(:erp_core_user, :confirmed) }
  let(:email)   { "worker@test.com" }
  let(:role)    { "worker" }

  def call_service(email:)
    described_class.new(
      account: account,
      role_name: role,
      email: email,
      inviter: inviter
    ).call
  end

  describe "#call" do
    context "when email is blank" do
      it "raises CreateWorker::Error" do
        expect {
          call_service(email: nil)
        }.to raise_error(ErpWorkers::CreateWorker::Error, "Email inválido")
      end
    end

    context "when user does not exist" do
      it "creates a user, joins account and assigns role" do
        allow_any_instance_of(ErpCore::User)
          .to receive(:send_reset_password_instructions)

        expect {
          user = call_service(email: email)

          expect(user.email).to eq(email)
          expect(user.accounts).to include(account)
          expect(user.has_role?(role, account: account)).to be(true)
        }.to change { ErpCore::User.where(email: email).count }.by(1)
      end


      it "sends reset password instructions" do
        expect_any_instance_of(ErpCore::User)
          .to receive(:send_reset_password_instructions)

        call_service(email: email)
      end
    end

    context "when user already exists" do
      let!(:existing_user) { create(:erp_core_user, :confirmed, email: email) }

      it "does not create a new user" do
        allow_any_instance_of(ErpCore::User)
          .to receive(:send_reset_password_instructions)

        expect {
          user = call_service(email: email)
          expect(user).to eq(existing_user)
        }.not_to change { ErpCore::User.where(email: email).count }
      end
    end

    context "when save raises ActiveRecord::RecordInvalid" do
      it "wraps the error in CreateWorker::Error" do
        invalid_user = build(:erp_core_user)
        invalid_user.errors.add(:email, "ya existe")

        allow(ErpCore::User)
          .to receive(:find_or_initialize_by)
          .and_return(invalid_user)

        allow(invalid_user)
          .to receive(:save!)
          .and_raise(ActiveRecord::RecordInvalid.new(invalid_user))

        expect {
          call_service(email: email)
        }.to raise_error(
          ErpWorkers::CreateWorker::Error,
          "Correo electrónico ya existe"
        )
      end
    end
  end
end
