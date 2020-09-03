require 'rails_helper'

feature 'User owner delete his ad' do
  scenario 'sucessfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.first)).click
    click_on 'Editar'
    fill_in 'Descrição', with: 'Teclado membrana Bright. Ele é um modelo menor que não possui o teclado numérico.'
    fill_in 'Preço', with: '30'
    click_on 'Cadastrar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Edição feita com sucesso.')
    expect(page).to have_content('Teclado membrana Bright. Ele é um modelo menor que não possui o teclado numérico.')
    expect(page).to have_content('R$ 30,00')
    expect(page).to have_content('Teclado')
    expect(page).to have_content('Eletrônicos')
  end

  scenario 'cant let any field blank' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click
    click_on 'Editar'
    fill_in 'Produto', with: ''
    fill_in 'Preço', with: ''
    click_on 'Cadastrar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Produto não pode ficar em branco')
    expect(page).to have_content('Preço não pode ficar em branco')
  end

  scenario 'only the owner of the ad can edit' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: another_user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click
    click_on 'Editar'
    fill_in 'Produto', with: 'Relógio'
    click_on 'Cadastrar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Sem autorização para editar este anúncio.')

  end

end