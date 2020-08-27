require 'rails_helper'

feature 'User view home page'do

  scenario 'successfully, but must to be logged in' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    login_as(user, scope: :user)
    visit root_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Bem vindo ao marketplace')
    #expect(page).to have_link('Perfil', href: new_car_category_path)
    
  end

end