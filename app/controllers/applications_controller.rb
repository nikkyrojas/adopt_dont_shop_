class ApplicationsController < ApplicationController
    def show
        @application = Application.find(params[:id])
        @pets = Pet.all
        if params[:search].present?
            @pets = Pet.search(params[:search])
         end
    end

    def new
    end

    def create
        application = Application.new(application_params)
        if application.save
            redirect_to "/applications/#{application.id}"
        else  
            redirect_to "/applications/new"
            flash[:alert] = "#{error_message(@application.errors)}"
        end
    end

    def update
        application = Application.find(params[:id])
        if params[:pet_id].present?
            pet = Pet.find(params[:pet_id])
            PetApplication.create!(application: application, pet: pet)
        elsif params[:submit].present?
            application.description = params[:description]
            application.status = "Pending"
            application.save
        end
        redirect_to "/applications/#{application.id}"
    end
    
    private

    def application_params
        params.permit(:applicant_name, :street_address, :city, :state, :zip_code, :description, :status)
    end
end