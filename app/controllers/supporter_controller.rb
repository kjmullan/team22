class SupporterController < ApplicationController
    before_action :authenticate_user!

    def new
    end

    def edit
    end

    def create
    end

    def update
    end

    def destroy
    end

    def resource_name
        :young_person
    end

    def resource_class
        YoungPerson
    end

    def resource
        @resource ||= YoungPerson.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:young_person]
    end
end