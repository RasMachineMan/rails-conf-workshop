require 'waterfall'
require 'pry'

module Services
  module User
    class Credit

      include ActiveModel::Validations
      include Waterfall

      validates :cents, numericality: { greater_than: 0 }

      def initialize(user:, cents:, source:)
        @user, @cents, @source = user, cents, source
      end

      def call
        # goal:
        # this object must take care of logic concerning payment
        # return false unless invitation_accepted?
        # pay_inviter
        # notify_payment
        # true
        when_falsy { valid? }
          .dam { errors }
        when_falsy { invitation_accepted? }
          .dam { errors.add :SUC1, 'Invitation needs to be accepted' }
        chain(:credit) { pay_inviter }
        chain { notify_payment }
      end

      private

      attr_reader :user, :cents, :source

      def pay_inviter
        CreditTransaction.create!(user: user, source: source, cents: cents)
      end

      def notify_payment
        AppMailer.notify_payment(outflow.credit).deliver_later
      end

      def invitation_accepted?
        source.accepted?
      end

    end
  end
end
