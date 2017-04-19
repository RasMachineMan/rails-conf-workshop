class Invitation < ActiveRecord::Base

  belongs_to :invitee, class_name: 'User', optional: true
  belongs_to :inviter, class_name: 'User'

  validates :invitee_email, presence: true

  # after_create :send_invitation_email
  # before_save  :set_pay_inviter, if: ->{ accepted_changed? && accepted? }
  # after_commit :pay_inviter, if: ->{ pay_inviter? }


  # def pay_inviter
  #   credit = CreditTransaction.create(user: inviter, source: self, cents: 500)
  #   AppMailer.notify_payment(credit).deliver_later
  # end

  # def pay_inviter?
  #   @must_pay_inviter
  # end

  # def set_pay_inviter
  #   @must_pay_inviter = true
  # end

  # def send_invitation_email
  #   AppMailer.invitation_email(self).deliver_later
  # end
end
