require 'rails_helper'

RSpec.describe "create new doctors" do
    it 'displays link that starts an application' do
        visit "/pets"
        expect(page).to have_link("Start Application")
    end
    
    it 'redirects to new application form' do
        visit "/pets"
        click_link("Start Application")
        save_and_open_page
        expect(page).to have_current_path("/applications/new")
    end

    it 'displays new content in new page' do
        visit "/applications/new"
        expect(page).to have_content("New Application")
    end

    it 'submits informations from form' do
        visit "/applications/new"
        
        fill_in "Name", with: "Phil McGraw"
        fill_in "Street Address", with: "453786"
        fill_in "City", with: "false"
        fill_in "State", with: "false"
        fill_in "Zip code", with: "false"
        fill_in "Descrpition", with: "false"

        click_button "Submit Application"
        expect(page).to have_current_path("/applications")
    end
end