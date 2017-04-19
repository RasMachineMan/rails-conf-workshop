require 'waterfall'
require 'pry'

class InvitationsController < ApplicationController

  include Waterfall

  def accept
    # if invitation.accepted?
    #   render json: { errors: ['Invitation already accepted'] }, status: 422
    # else
    #   user = User.create_from_invitation(invitation)
    #   invitation.accepted = true
    #   invitation.save
    #   render json: { user: user }
    # end
    Wf.new
      .chain(user: :user) { ::Services::Invitation::Accept.new(invitation) }
      .chain do |outflow|
        render json: { user: outflow.user }
      end
      .on_dam do |error_pool|
        render json: { errors: error_pool }, status: 422
      end
  end

  private

  def invitation
    @invitation ||= Invitation.find(params[:id])
  end
end
