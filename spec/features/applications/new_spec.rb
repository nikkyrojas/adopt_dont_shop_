require 'rails_helper'

RSpec.describe "create new doctors" do
    it 'displays link that starts an application' do
        visit "/pets"
        expect(page).to have_link("Start Application")
    end
    
    it 'redirects to new application form' do
        visit "/pets"
        click_link("Start Application")
        expect(page).to have_current_path("/applications/new")
    end
    
    it 'displays new form content' do
        visit "/applications/new"
        expect(page).to have_content("New Application")
    end
    
    it 'submits informations from form' do
        visit "/applications/new"
        
        fill_in "Applicant name", with: "Brittney Spears" #, visible: false
        fill_in "Street address", with: "453 19th St"
        fill_in "City", with: "Clabasas"
        fill_in "State", with: "CA"
        fill_in "Zip code", with: "60254"
        fill_in "Description", with: "I have adopted many and I love them all"
        
        click_button "Submit Application"
        expect(page).to have_current_path("/applications/#{Application.first.id}")
    end

    it 'if any form field incomplete, takes user back to the new applications page' do
        application_4 = Application.create!(applicant_name: 'Doja Cat', street_address: '9742 Billings St', city: 'Aurora', state: 'CO', zip_code: '80245', description: 'I need an emotional support animal', status: 'in progress')
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter_1)

        visit "/applications/new"

        fill_in "Applicant name", with: "#{application_4.applicant_name}"
        fill_in "Street address", with: "#{application_4.street_address}"
        # Use Case: What if user misses writing their City? # fill_in "City", with: "#{application_4.city}"
        fill_in "State", with: "#{application_4.state}"
        fill_in "Zip code", with: "#{application_4.zip_code}"
        fill_in "Description", with: "#{application_4.description}"
        # fill_in "Status", with: "#{application_4.status}"  Unable to find field "Status" that is not disabled
        
        # expect(page).to have_content("#{application_4.applicant_name}")
        # expect(page).to have_content("#{application_4.street_address}")
        # expect(page).to have_content("#{application_4.state}")
        # expect(page).to_not have_content("#{application_4.city}")
        # expect(page).to have_content("#{application_4.zip_code}")
        # expect(page).to have_content("#{application_4.description}")

        click_button "Submit Application"

        expect(current_path).to eq("/applications/new")
        expect(page).to have_content("Error")
    end
end