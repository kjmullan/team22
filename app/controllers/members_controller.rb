class MembersController < ApplicationController
    def index
        return redirect_to login_path unless current_user.present?
  
        @members = current_user.young_person.invites
    end

    def show
    end

    def create
        @member = current_user.young_person.invites.new(member_params)
        if @member.save
          redirect_to [@member], notice: 'Member was successfully created.'
        else
          render :new
        end
    end

    def update
        if @member.update(member_params)
            redirect_to [ @member], notice: 'Member was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @member.destroy
        redirect_to members_url, notice: 'Member was successfully destroyed.'
    end
end