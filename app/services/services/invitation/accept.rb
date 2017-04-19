require 'waterfall'
require 'pry'

module Services
  module Invitation
    class Accept

      include Waterfall

      def initialize(invitation)
        @invitation = invitation
      end

      def call
        # would host code from invitations_controller
        # return false if invitation.accepted?
        # toggle_inviatation_status
        # create_user_from_invitation
        when_falsy { invitation_available? }
          .dam { errors.add :SIA, 'Invitation already accepted' }
        chain(user: :user) { create_user_from_invitation }
        chain { toggle_inviatation_status }
        chain { credit }
        chain(:user) { outflow.user }
      end

      private

      attr_reader :invitation

      def invitation_available?
        !invitation.accepted?
      end

      def toggle_inviatation_status
        invitation.accepted = true
        invitation.save!
      end

      def create_user_from_invitation
        ::Services::User::CreateFromInvitation.new(invitation)
      end

      def credit
        ::Services::User::Credit.new(
          user: invitation.inviter,
          cents: invitation.inviter.affilation_earnings_cents,
          source: invitation
        )
      end

    end
  end
end
