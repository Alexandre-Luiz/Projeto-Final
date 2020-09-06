require 'rails_helper'

feature 'User view on his profile, his products' do
  scenario 'successfully' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com')
    Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                    description: 'Teclado com pouquíssimo uso. Possui RGB', 
                    price: 200, user: another_user, status: :disabled)
    Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                    description: 'Bola oficial da copa 2014. Nunca foi usada', 
                    price: 500, user: user, status: :enabled)
    Product.create!(name: 'PS4', category: 'Brinquedos e games', 
                    description: 'Está em perfeitas condições. Acompanha dois jogos.', 
                    price: 3000, user: user, status: :enabled)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Meus produtos'

    expect(page).to have_content('Bola de futebol')
    expect(page).to have_content('PS4')
    expect(page).not_to have_content('Teclado mecânico Logitech')
  end

  scenario 'and can access the details of the ones without order' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com')
    Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                    description: 'Bola oficial da copa 2014. Nunca foi usada', 
                    price: 500, user: user, status: :enabled)
    Product.create!(name: 'PS4', category: 'Brinquedos e games', 
                    description: 'Está em perfeitas condições. Acompanha dois jogos.', 
                    price: 3000, user: user, status: :enabled)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Meus produtos'
    find_link('Detalhes', href: product_path(Product.last)).click

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Preço: R$ 3.000,00')
    expect(page).to have_content('Detalhes:')
    expect(page).to have_content('Vendedor: Fernando')
    expect(page).to have_content('Email: fernando@test.com')
    expect(page).to have_content('Brinquedos e games')
  end

  scenario 'and can access the order on the ones with order pending' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com')
    another_product = Product.create!(name: 'PS4', category: 'Brinquedos e games', 
                                      description: 'Está em perfeitas condições. Acompanha dois jogos.', 
                                      price: 3000, user: user, status: :enabled)
    product = Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                    description: 'Bola oficial da copa 2014. Nunca foi usada', 
                    price: 500, user: user, status: :disabled)

    Order.create!(discount: 100, payment_method: 'Dinheiro', address: 'Rua do matão, 100',
                  comment: 'Desconto que combinamos no almoço', user: another_user, product: product)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Meus produtos'
    find_link('Analisar', href: product_my_order_path(product.id)).click


    expect(page).to have_content('Bola de futebol')
    expect(page).to have_content('Preço: R$ 500,00')
    expect(page).to have_content('Detalhes')

    expect(page).to have_content('Pedido para análise:')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('Dinheiro')
    expect(page).to have_content('Desconto que combinamos no almoço')
    expect(page).to have_content('Rua do matão, 100')

  end
end