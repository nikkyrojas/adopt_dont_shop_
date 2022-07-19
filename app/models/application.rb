class Application < ApplicationRecord
    has_many :pet_applications
    has_many :pets, through: :pet_applications
    validates_presence_of :applicant_name
    validates_presence_of :street_address
    validates_presence_of :city
    validates_presence_of :state
    validates_presence_of :zip_code
    validates_presence_of :status
    validates_presence_of :description

    def address
        application = Application.last
        address = application.street_address + " " + application.city  + " " + application.state  + " " + application.zip_code
        address.upcase
    end

    def status
        application = Application.last
        application.status = "In progress"
    end

    # def added_pets

    # end
end
