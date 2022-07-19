require 'rails_helper'

RSpec.describe 'the show page' do

  before(:each) do
      @application_1 = Application.create!(applicant_name: 'Bob Ross', street_address: '8753 Main St', city: 'Longmont', state: 'CO', zip_code: '80765', description: 'I make a lot of money', status: 'In Progress')
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter_1.id)
      @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
      @pet_3 = Pet.create(adoptable: true, age: 1, breed: 'pit', name: 'Lobely', shelter_id: @shelter_1.id)
      
      @pet_app1 = PetApplication.create(pet_id: @pet_1.id, application_id: @application_1.id)
      @pet_app1 = PetApplication.create(pet_id: @pet_2.id, application_id: @application_1.id)
  end

  it "show the applicantion with attributes such as name address status and description" do
    visit "/applications/#{@application_1.id}"

    expect(page).to have_content(@application_1.applicant_name)
    expect(page).to have_content(@application_1.street_address.upcase)
    expect(page).to have_content(@application_1.description)
    expect(page).to have_content(@application_1.status)
    expect(page).to have_content(@pet_1.name)
    expect(page).to have_content(@pet_2.name)
  end

  it "has a link, link goes to each pets show page" do
    visit "/applications/#{@application_1.id}"

    expect(page).to have_link("Bare-y Manilow")
    click_on("Bare-y Manilow")
    expect(page).to have_current_path("/pets/#{@pet_1.id}")
  end

  it 'has a search box to filter pets by key word' do
    visit "/applications/#{@application_1.id}"
    expect(page).to have_button("Search")
  end

  it 'lists matched/partial matched pets based on search' do
    visit "/applications/#{@application_1.id}"

    fill_in 'Search', with: "Lob"
    click_on("Search")

    expect(page).to have_content(@pet_2.name)
    expect(page).to_not have_content(@pet_1.name)
  end

  it 'has a button to submit application' do
    visit "/applications/#{@application_1.id}"

    fill_in 'Search', with: "Lob"
    click_on("Search")
    expect(page).to have_button("Submit")
  end
  
  it 'has an adopt this pet button' do
    visit "/applications/#{@application_1.id}"
    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'Search', with: 'Chungus'
    click_button 'Submit'

    expect(current_path).to eq("/applications/#{@application_1.id}")

    expect(page).to have_button("Adopt this Pet")
  end

  it "adopt this pet button adds a pet to the application" do
    visit "/applications/#{@application_1.id}"
    
    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'Search', with: 'Lobster'
    click_button 'Submit'
    click_button 'Adopt this Pet'
    expect(page).to have_content("Applying for pet: Lobster")
  end

  it 'displays section to input description and submit application when dog count > 0' do
    visit "/applications/#{@application_1.id}"

    # fill_in 'Search', with: 'Lobster'
    # click_button 'Submit'
    # click_button 'Adopt this Pet'

    fill_in 'description', with: 'Testing'
    click_button 'Submit Application'

    save_and_open_page
    expect(page).to have_content("Pending")
    expect(page).to have_content("Lobster")
  end
end
