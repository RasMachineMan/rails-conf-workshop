require 'spec_helper'

describe Services::User::Credit do

  let(:service)     { described_class.new(user: user, cents: cents, source: invitation) }
  let!(:invitation) { Factories.create_invitation }
  let(:user)        { invitation.inviter }

  let(:params) {{
    accepted: true,
    inviter: create_user,
    invitee_email: 'invitee@example.com'
  }}

  def create_user(params = nil)
    ::User.create!(default_user_params)
  end

  def default_user_params
    {
      email: "foo-#{ SecureRandom.uuid }@example.com",
      name:  'john doe'
    }
  end

  let!(:invitation2) { Factories.create_invitation(params) }
  let(:service2)     { described_class.new(user: user, cents: cents, source: invitation2) }

  context 'valid' do
    let(:cents) { 200 }

    it 'sends email' do
      expect(AppMailer).to receive_message_chain(:notify_payment, :deliver_later)
      service2.call
    end

    it 'creates transaction' do
      expect { service2.call }.to change { user.affilation_earnings_cents }.by(cents)
    end
  end

  context 'invalid' do
    let(:cents) { -200 }
    it 'doesnt changed user balance' do
      expect { service.call }.to_not change { user.affilation_earnings_cents }
    end
  end
end
