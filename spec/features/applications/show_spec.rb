require 'rails_helper'

RSpec.describe 'the show page' do

  before(:each) do
      @application_1 = Application.create!(applicant_name: 'Bob Ross', street_address: '8753 Main St', city: 'Longmont', state: 'CO', zip_code: '80765', description: 'I make a lot of money', status: 'In Progress')
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter_1.id)
   
      @pet_app1 = PetApplication.create(pet_id: @pet_1.id, application_id: @application_1.id)
  end

  it "show the application with attributes such as name address status and description" do
    visit "/applications/#{@application_1.id}"

    expect(page).to have_content(@application_1.applicant_name)
    expect(page).to have_content(@application_1.street_address.upcase)
    expect(page).to have_content(@application_1.description)
    expect(page).to have_content(@application_1.status)
  end

  it "pet results has a link, link goes to each pets show page" do
    luna = Pet.create(adoptable: true, age: 1, breed: 'poodle', name: 'Luna', shelter_id: @shelter_1.id)

    visit "/applications/#{@application_1.id}"
    
    fill_in 'Search', with: "Luna"
    click_on("Search")

    within "#pets-#{luna.id}" do
      expect(page).to have_link("Luna")
      click_on("Luna")
      expect(page).to have_current_path("/pets/#{luna.id}")
    end
  end

  it "pets added has a link, link goes to each pets show page" do
    luna = Pet.create(adoptable: true, age: 1, breed: 'poodle', name: 'Luna', shelter_id: @shelter_1.id)

    visit "/applications/#{@application_1.id}"
    
    fill_in 'Search', with: "Luna"
    click_on("Search")
    click_on("Add Pet")

    within "#addpets-#{luna.id}" do
      expect(page).to have_link("Luna")
      click_on("Luna")
      expect(page).to have_current_path("/pets/#{luna.id}")
    end
  end

  it 'has a search box to filter pets by key word' do
    visit "/applications/#{@application_1.id}"
    expect(page).to have_button("Search")
  end

  it 'lists matched/partial matched pets based on search' do

    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
    pet_3 = Pet.create(adoptable: true, age: 1, breed: 'pit', name: 'Lobely', shelter_id: @shelter_1.id)
    
    visit "/applications/#{@application_1.id}"

    fill_in 'Search', with: "Lob"
    click_on("Search")

    within "#pets-#{pet_2.id}" do
      expect(page).to have_content(pet_2.name)
      expect(page).to_not have_content(@pet_1.name)
    end
  end

  it 'has a button to submit application' do
    @application_2 = Application.create!(applicant_name: 'Bob Ross', street_address: '8753 Main St', city: 'Longmont', state: 'CO', zip_code: '80765', description: 'I make a lot of money', status: 'rejected')
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
    
    visit "/applications/#{@application_2.id}"

    fill_in 'Search', with: "Lob"
    click_on("Search")
    expect(page).to have_button("Submit")
  end
  
  it 'has an adopt pet button' do
    application_2 = Application.create!(applicant_name: 'Bob Ross', street_address: '8753 Main St', city: 'Longmont', state: 'CO', zip_code: '80765', description: 'I make a lot of money', status: 'rejected')
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
    
    visit "/applications/#{application_2.id}"

    fill_in 'Search', with: 'Lobster'
    click_button 'Search'

    expect(current_path).to eq("/applications/#{application_2.id}")
    expect(page).to have_button("Add Pet")
  end

  it "adopt this pet button adds a pet to the application" do
   dani = Application.create!(
                 applicant_name: 'Dani Coleman',
                 street_address: '912 Willow St',
                 city: 'Arvada',
                 state: 'Colorado',
                 zip_code: '80003',
                 status: 'In Progress')
    foothills = Shelter.create!(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: false, rank: 9)
    vida = Pet.create!(adoptable: true, age: 4, breed: 'Yorkshire', name: 'Vida', shelter_id: foothills.id)
    visit "/applications/#{dani.id}"
    
    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'Search', with: 'vida'
    click_button 'Search'
    click_button 'Add Pet'

    # application_2.add_pet
    expect(current_path).to eq("/applications/#{dani.id}")
    expect(page).to have_content("Vida")
  end

  # it 'displays section to input description and submit application when dog count > 0' do
  #   visit "/applications/#{@application_1.id}"

  #   # fill_in 'Search', with: 'Lobster'
  #   # click_button 'Submit'
  #   # click_button 'Adopt this Pet'

  #   fill_in 'description', with: 'Testing'
  #   click_button 'Submit Application'

  #   save_and_open_page
  #   expect(page).to have_content("Pending")
  #   expect(page).to have_content("Lobster")
  # end
end
