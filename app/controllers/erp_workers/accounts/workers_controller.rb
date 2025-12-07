# frozen_string_literal: true

module ErpWorkers
  module Accounts
    class WorkersController < ErpWorkers::ApplicationController
      before_action :authenticate_user!
      before_action :load_account
      before_action :authorize_owner!

      def index
        @workers = @account.users.includes(:roles)
      end

      def create
        svc = ErpWorkers::CreateWorker.new(
          account: @account,
          role_name: worker_params[:role],
          email: worker_params[:email],
          inviter: current_user
        )

        user = svc.call

        respond_to do |format|
          format.html do
            flash[:notice] = "Invitación enviada a #{user.email}"
            redirect_to erp_workers.accounts_workers_path(account_id: @account.id)
          end
          format.json { render json: { success: true, user: user.as_json(only: [ :id, :email ]) }, status: :created }
          format.turbo_stream do
            @user = user
            @workers = @account.users.workers.includes(:roles)
            render "create_success"
          end
        end
      rescue ErpWorkers::CreateWorker::Error => e
        respond_to do |format|
          format.html do
            flash[:alert] = e.message
            redirect_to erp_workers.accounts_workers_path(account_id: @account.id)
          end
          format.json { render json: { error: e.message }, status: :unprocessable_content }
          format.turbo_stream do
            @error = e.message
            render "create_error"
          end
        end
      end

      def destroy
        user = ErpCore::User.find(params[:id])
        user.user_accounts.where(account: @account).delete_all
        @user = user
        @workers = @account.users.workers.includes(:roles)
        respond_to do |format|
          format.turbo_stream { render "destroy" }
          format.html do
            redirect_to erp_workers.accounts_workers_path(account_id: @account.id), notice: I18n.t("erp_workers.accounts.workers.delete_worker_successfully")
          end
          format.json { head :no_content }
        end
      end

      private

      def load_account
        @account = ErpCore::Account.find(params[:account_id] || params[:id] || params[:worker]&.dig(:account_id))
      end

      def authorize_owner!
        unless current_user.has_role?("owner", account: @account)
          redirect_to erp_users.accounts_dashboard_path(@account.id), alert: I18n.t("erp_workers.accounts.workers.not_unauthorized")
        end
      end

      def worker_params
        params.expect(:worker [:email, :role])
      end
    end
  end
end
