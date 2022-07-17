class ApplicationsController < ApplicationController
    def index
        @applications = Application.all
    end

    def show
        @application = Application.find(params[:id])
        @pets = Pet.all.adoptable
        if params[:search].present?
            @matched_pets = Pet.search(params[:search])
 
        end
        # binding.pry
    end

    def new
    end

    def create
        @application = Application.create!(applicant_name: params[:applicant_name], street_address: params[:street_address], city: params[:city], state: params[:state], zip_code: params[:zip_code], description: "", status: "In Progress")
      
        if @application.save
            redirect_to "/applications/#{@application.id}"
        elseif @application[:name].empty? || @application[:street_address].empty? || @application[:city].empty? || @application[:state].empty? || @application[:zip_code].empty?
            redirect_to "/applications/new"
            flash[:alert] = "Error: #{error_message(@application.errors)}"
        end
    end

    def add_pet
        PetApplication.create!(pet_id: params[:chosen_pet], application_id: params[:id])
        application = Application.find(params[:id])
        application.description = params[:description]
        application.save
        redirect_to "/applications/#{params[:id]}"
    end

    private

    def application_params
        params.permit(:applicant_name, :street_address, :city, :state, :zip_code, :description, :status)
    end
end



#   def submit_application
#     application = Application.find(params[:id])
#     application.description = params[:description]
#     application.status = "Pending"
#     application.save
#     redirect_to "/applications/#{params[:id]}"
#   end