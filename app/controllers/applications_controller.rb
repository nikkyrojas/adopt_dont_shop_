class ApplicationsController < ApplicationController
    def index
        @applications = Application.all
    end

    def show
        # binding.pry
        @application = Application.find(params[:id])
        if params[:search].present?
            @pets = Pet.search(params[:search])
        else
            @pets = Pet.adoptable
        end
    end

    def new
    end

    def create
        @application = Application.create(application_params)
   
        redirect_to "/applications/#{@application.id}"
       
    end

    private
    def application_params
        params.permit(:applicant_name, :street_address, :city, :state, :zip_code, :description, :status)
    end

    # def address
    #     @application = Application.find(params[:id])
    #     binding.pry
    #     @application = Application.create(application_params)
    # end

end
