class ApplicationsController < ApplicationController
    def index
        @applications = Application.all
    end

    def show
        # binding.pry
        @application = Application.find(params[:id])
        @pets = @application.pets
    end

    def new
    end

    def create
        @application = Application.create(application_params)
        redirect_to "/applications"
       
    end

    private
    def application_params
        params.permit(:applicant_name, :street_address, :city, :state, :zip_code, :description, :status)
    end

end
