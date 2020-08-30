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
    fill_in 'Nome', with: 'Teclado'
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
end