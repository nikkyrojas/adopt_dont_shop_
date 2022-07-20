class PetApplicationsController < ApplicationController
    def index
    end

    def create
        @application = Application.find(params[:application_id])
        @pet = Pet.find(params[:pet_id])

        PetApplication.create!(pet_id: @pet.id, application_id: @application.id)
        redirect_to "/applications/#{@application.id}"
    end
end

