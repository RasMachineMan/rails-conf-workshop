require 'waterfall'
require 'pry'

module Services
  module User
    class CreateFromInvitation

      include Waterfall

      def initialize(invitation)
        @invitation = invitation
      end

      def call
        # goal:
        # - remove email sending from user model
        # - remove import_context from User model
        # - remove after create altogether
        # ::User.create_from_invitation(invitation)
        # create_from_invitation
        # update_invitee
        # send_email
        # user
        chain(:user) { create_from_invitation }
        when_falsy { outflow.user.valid? }
          .dam { outflow.user.errors }
        chain { update_invitee }
        chain { send_email }
      end

      private

      attr_reader :invitation

      def create_from_invitation
        ::User.create(email: invitation.invitee_email)
      end

      def update_invitee
        invitation.update(invitee: outflow.user)
      end

      def send_email
        AppMailer.welcome_email(outflow.user).deliver_later
      end

    end
  end
end
