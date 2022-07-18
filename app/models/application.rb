class Application < ApplicationRecord
    has_many :pet_applications
    has_many :pets, through: :pet_applications

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
