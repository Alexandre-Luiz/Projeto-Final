require 'rails_helper'

feature 'User searches the listed products' do
  scenario 'successfully by its name - exact match' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)
    Product.create!(name: 'Mouse', category: 'Eletrônicos', 
                    description: 'Mouse logitech sem fio', price: '500', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    fill_in 'Busca', with: 'Teclado'
    click_on 'Buscar'

    expect(page).to have_content('Teclado')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('Fulano')
    expect(page).not_to have_content('mouse')
    expect(page).not_to have_content('R$ 500,00')
  end

  scenario 'successfully by its name - partial match' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)
    Product.create!(name: 'Mouse', category: 'Eletrônicos', 
                    description: 'Mouse logitech sem fio', price: '500', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    fill_in 'Busca', with: 'tec'
    click_on 'Buscar'

    expect(page).to have_content('Teclado')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('Fulano')
    expect(page).not_to have_content('mouse')
    expect(page).not_to have_content('R$ 500,00')
  end

  scenario 'successfully by its category - exact match' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)
    Product.create!(name: 'Fiat Uno', category: 'Automotivo', 
                    description: 'Fiat Uno 2017 com 100 mil quilômetros', price: '35000', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    fill_in 'Busca', with: 'eletrônicos'
    click_on 'Buscar'

    expect(page).to have_content('Teclado')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('Fulano')
    expect(page).not_to have_content('Fiat Uno')
    expect(page).not_to have_content('R$ 35.000,00')
  end

  scenario 'successfully by its category - partial match' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)
    Product.create!(name: 'Fiat Uno', category: 'Automotivo', 
                    description: 'Fiat Uno 2017 com 100 mil quilômetros', price: '35000', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    fill_in 'Busca', with: 'eletr'
    click_on 'Buscar'

    expect(page).to have_content('Teclado')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('Fulano')
    expect(page).not_to have_content('Fiat Uno')
    expect(page).not_to have_content('R$ 35.000,00')
  end

end