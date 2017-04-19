module Services
  module Invitation
    class Create

      attr_reader :invitation

      def initialize(inviter:, email:)
        @inviter, @invitee_email = inviter, email
      end

      def call
        # remove after create callback from invitation
        create_inviatation
        send_invitation_email
      end

      private

      attr_reader :inviter, :invitee_email

      def create_inviatation
        @invitation = ::Invitation.create(
          inviter: inviter,
          invitee_email: invitee_email
        )
      end

      def send_invitation_email
        AppMailer.invitation_email(invitation).deliver_later
      end


    end
  end
end
