require 'rails_helper'

feature 'User register product to sell'do
  scenario 'successfuly' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Cadastrar produto'
    fill_in 'Nome', with: 'Teclado'
    select 'Eletrônicos', from: 'Categoria'
    fill_in 'Descrição', with: 'Teclado mecânico com pouquíssimo uso com RGB'
    fill_in 'Preço', with: '200'
    click_on 'Cadastrar'

    #expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content(current_user.name)
    expect(page).to have_content('Produto cadastrado com sucesso!')
    expect(page).to have_content('Teclado')
    expect(page).to have_content('Eletrônicos')
    expect(page).to have_content('R$ 200')
    expect()
  end

  xscenario 'but must finish his profile first' do
  end

end