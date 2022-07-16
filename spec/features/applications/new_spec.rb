require 'rails_helper'

RSpec.describe "create new doctors" do
    it 'displays link that starts an application' do
        visit "/pets"
        expect(page).to have_link("Start Application")
    end
    
    it 'redirects to new application form' do
        visit "/pets"
        click_link("Start Application")
        # save_and_open_page
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
end