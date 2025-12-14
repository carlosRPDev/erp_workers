# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ErpWorkers::Accounts::WorkersController", type: :request do
  let(:account) { create(:erp_core_account) }
  let(:owner)   { create(:erp_core_user, :confirmed) }
  let(:worker)  { create(:erp_core_user, :confirmed) }

  before do
    owner.join_account(account, owner: true)
    owner.add_role("owner", account: account)
  end

  describe "GET /accounts/:account_id/workers" do
    context "when user is owner" do
      it "renders workers list" do
        sign_in(owner)

        get erp_workers.accounts_workers_path(account_id: account.id)

        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not owner" do
      it "redirects with alert" do
        sign_in(worker)
        worker.join_account(account)

        get erp_workers.accounts_workers_path(account_id: account.id)

        expect(response).to redirect_to(
          erp_accounts.account_path(account.id)
        )
      end
    end
  end

  describe "POST /accounts/:account_id/workers" do
    before { sign_in(owner) }

    context "when service succeeds (HTML)" do
      let(:service_double) { instance_double(ErpWorkers::CreateWorker) }
      let(:new_user) { create(:erp_core_user, :confirmed) }

      before do
        allow(ErpWorkers::CreateWorker).to receive(:new).and_return(service_double)
        allow(service_double).to receive(:call).and_return(new_user)
      end

      it "creates worker and redirects with notice" do
        post erp_workers.accounts_workers_path(account_id: account.id), params: {
          worker: {
            email: "worker@test.com",
            role: "worker"
          }
        }

        expect(response).to redirect_to(
          erp_workers.accounts_workers_path(account_id: account.id)
        )

        expect(flash[:notice]).to include("Invitación enviada")
      end
    end
  end

  describe "DELETE /accounts/:account_id/workers/:id" do
    before do
      sign_in(owner)
      worker.join_account(account)
    end

    it "removes worker from account and redirects" do
      delete erp_workers.accounts_worker_path(
        account_id: account.id,
        id: worker.id
      )

      expect(response).to redirect_to(
        erp_workers.accounts_workers_path(account_id: account.id)
      )
    end
  end
end
