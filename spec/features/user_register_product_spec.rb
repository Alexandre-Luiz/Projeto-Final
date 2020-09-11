require 'rails_helper'

feature 'User register product to sell'do
  scenario 'successfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    click_on 'Cadastrar Produto'
    fill_in 'Produto', with: 'Teclado'
    select 'Eletrônicos', from: 'Categoria'
    fill_in 'Descrição', with: 'Teclado mecânico com pouquíssimo uso com RGB'
    fill_in 'Preço', with: '200'
    click_on 'Cadastrar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content(user.name)
    expect(page).to have_content('Produto colocado a venda com sucesso!')
    expect(page).to have_content('Teclado')
    expect(page).to have_content('Eletrônicos')
    expect(page).to have_content('R$ 200')
  end

  scenario 'but must finish his profile first' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user, status: :enabled)

    login_as(user, scope: :user)
    visit new_product_path
    click_on 'Cadastrar'

    #expect(page).not_to have_button('Cadastrar Produto')
    expect(page).to have_content('Por favor, complete o perfil para cadastrar produto')
  end

  scenario 'and cant see the button to register' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'

    expect(page).not_to have_button('Cadastrar Produto')
  end

  scenario 'must fill all fields of the form' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    click_on 'Cadastrar Produto'
    click_on 'Cadastrar'

    expect(page).to have_content('Produto não pode ficar em branco')
    expect(page).to have_content('Categoria não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Preço não pode ficar em branco')
  end

  scenario 'and can attach an image' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos' )

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    click_on 'Cadastrar Produto'
    fill_in 'Produto', with: 'Furadeira'
    select 'Ferramentas', from: 'Categoria'
    fill_in 'Descrição', with: 'Acompanha kit de brocas'
    fill_in 'Preço', with: '200'
    attach_file 'Foto', Rails.root.join('spec/support/furadeira.png')
    click_on 'Cadastrar'

    expect(page).to have_css('img[src*="furadeira.png"]')
  end
end