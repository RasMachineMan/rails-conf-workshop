require 'waterfall'

module Services
  module User
    class Signup

      include ActiveModel::Validations
      include Waterfall

      validate :name_present

      def initialize(params)
        @params = params.slice(:email, :name)
      end

      def call
        # goal:
        # - edit after_create from user model
        # - remove name validation from user model but add it here
        # ::User.create(params)
        # create_user
        # send_email
        when_falsy { valid? }
          .dam { errors }
        chain(:user) { create_user }
        chain { send_email }
      end

      private

      attr_reader :params

      def name_present
        errors.add :SUS1, "Name needs to be present" unless params[:name].present?
      end

      def create_user
        ::User.create(params)
      end

      def send_email
        AppMailer.signup_email(outflow.user).deliver_later
      end

    end
  end
end
