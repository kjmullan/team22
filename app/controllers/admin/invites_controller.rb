# app/controllers/admin/invites_controller.rb
module Admin
  class InvitesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin

    def index
      @invites = Invite.order(created_at: :desc).page(params[:page])
    end

    def destroy
      @invite = Invite.find(params[:id])
      if @invite.destroy
        redirect_to admin_invites_path, notice: 'Invite was successfully destroyed.'
      else
        redirect_to admin_invites_path, alert: 'Failed to destroy the invite.'
      end
    end

    private

    def ensure_admin
      redirect_to(root_path, alert: 'Not authorized') unless current_user.admin?
    end
  end
end

  