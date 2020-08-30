require 'rails_helper'

feature 'User view all products' do
  scenario 'offered in his company' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com')
    another_another_user = User.create!(name: 'Pedro', password: '123456789', email: 'Pedro@test.com')
    Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                    description: 'Teclado com pouquíssimo uso. Possui RGB', 
                    price: 200, user: user)
    Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                    description: 'Bola oficial da copa 2014. Nunca foi usada', 
                    price: 500, user: another_another_user)
    Product.create!(name: 'PS4', category: 'Brinquedos e games', 
                    description: 'Está em perfeitas condições. Acompanha dois jogos.', 
                    price: 3000, user: another_user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'

    expect(page).to have_content('Teclado mecânico Logitech')
    expect(page).to have_content('R$ 200,00')
    expect(page).to have_content(user.name)
    expect(page).to have_content('Bola de futebol')
    expect(page).to have_content('R$ 500,00')
    expect(page).to have_link('Voltar', href: root_path)
    expect(page).not_to have_content('PS4')
    expect(page).not_to have_content(another_user.name)
  end

  scenario 'and view details' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com')
    Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                    description: 'Teclado com pouquíssimo uso. Possui RGB', 
                    price: 200, user: user)
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    click_on 'Ver detalhes'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content('Teclado mecânico Logitech')
    expect(page).to have_content('Eletrônicos')
    expect(page).to have_content('R$ 200,00')
    expect(page).to have_content('Teclado com pouquíssimo uso. Possui RGB')

  end
end
