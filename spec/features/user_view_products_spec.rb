require 'rails_helper'

feature 'User view all products' do
  scenario 'offered in his company' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com')
    Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                    description: 'Teclado com pouquíssimo uso. Possui RGB', 
                    price: 200, user: user)
    Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                    description: 'Bola oficial da copa 2014. Nunca foi usada', 
                    price: 500, user: user)
    Product.create!(name: 'PS4', category: 'Brinquedos e games', 
                    description: 'Está em perfeitas condições. Acompanha dois jogos.', 
                    price: 3000, user: another_user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'

    expect(page).to have_content('Teclado mecânico Logitech')
    expect(page).to have_content(200)
    expect(page).to have_content(user.name)
    expect(page).to have_content('Bola de futebol')
    expect(page).to have_content(500)
    expect(page).not_to have_content('PS4')
    expect(page).not_to have_content(another_user.name)
  end
end
