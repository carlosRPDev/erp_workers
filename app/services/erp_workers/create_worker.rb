# frozen_string_literal: true

module ErpWorkers
  class CreateWorker
    class Error < StandardError; end

    attr_reader :account, :role_name, :email, :inviter, :user

    def initialize(account:, role_name:, email:, inviter: nil)
      @account = account
      @role_name = role_name.to_s
      @email = email&.strip&.downcase
      @inviter = inviter
    end

    def call
      raise Error, "Email inválido" if email.blank?

      ActiveRecord::Base.transaction do
        @user = ErpCore::User.find_or_initialize_by(email: email)

        if @user.new_record?
          @user.skip_confirmation!
          @user.save!(validate: false)
        end

        @user.join_account(account)
        @user.add_role(role_name, account: account)

        @user.send_reset_password_instructions

        @user
      end
    rescue ActiveRecord::RecordInvalid => e
      raise Error, e.record.errors.full_messages.join(", ")
    end
  end
end
