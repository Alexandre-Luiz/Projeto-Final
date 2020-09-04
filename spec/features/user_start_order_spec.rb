require 'rails_helper'

feature 'User starts a buy order' do
  scenario 'sucessfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: another_user)
  
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.first)).click
    click_on 'Comprar'
    select 'Transferência bancária', from: 'Forma de pagamento'
    fill_in 'Desconto', with: '5'
    fill_in 'Endereço para entrega', with: 'Rua Pedroso cardoso, 300'
    fill_in 'Comentários adicionais', with: 'Conforme combinado, pode adicionar o frete no preço do produto'
    click_on 'Efetuar compra'

    expect(current_path).to eq product_order_path(Product.last, Order.last)
    expect(page).to have_content('Pedido realizado com sucesso!')
    expect(page).to have_content('Resumo do pedido:')
    expect(page).to have_content('R$ 5,00')
    expect(page).to have_content('R$ 15,00')
    expect(page).to have_content('Rua Pedroso cardoso, 300')
    expect(page).to have_content('Conforme combinado, pode adicionar o frete no preço do produto')
    expect(product.reload).to be_disabled
  end

  scenario 'product with an open order (disabled) shouldnt be visible on the index' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: another_user, status: :enabled)
    another_product = Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                    description: 'Bola oficial da copa 2014. Nunca foi usada', 
                    price: 500, user: another_user, status: :enabled)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click
    click_on 'Comprar'
    select 'Transferência bancária', from: 'Forma de pagamento'
    fill_in 'Desconto', with: 50
    fill_in 'Endereço para entrega', with: 'Av. Paulista, 1000'
    fill_in 'Comentários adicionais', with: 'Conforme combinamos, vou depositar o valor no primeiro dia útil do próximo mês.'
    click_on 'Efetuar compra'
    visit products_path

    expect(page).to have_content('Teclado')
    expect(page).to have_content('R$ 20,00')

    expect(page).not_to have_content('Bola de futebol')
    expect(page).not_to have_content('R$ 500,00')

  end

  scenario 'and search also must filter out disabled products' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado Cassio', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '1000', user: another_user, status: :disabled)
    another_product = Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                                      description: 'Teclado com pouquíssimo uso. Possui RGB', 
                                      price: 200, user: another_user, status: :enabled)
    Order.create!(discount: 10, payment_method: 'Dinheiro', address: 'Rua Pedroso alvarenga, 190', 
                  comment: 'Pagarei pessoalmente na nossa empresa', product: product, user: another_user)


    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    fill_in 'Busca', with: 'teclado'
    click_on 'Buscar'

    product.reload
    expect(page).to have_content('Teclado mecânico Logitech')
    expect(page).to have_content('R$ 200,00')

    expect(page).not_to have_content('Teclado Cassio')
    expect(page).not_to have_content('R$ 1000,00')
  end

  scenario 'and can return to product details' do
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
    find_link('Ver detalhes', href: product_path(Product.first)).click
    click_on 'Comprar'
    click_on 'Voltar'

    expect(current_path).to eq product_path(Product.last)
  end

  xscenario 'payment_method cant be blank' do

  end 

  xscenario 'owner changes price of the product after order' do
    
  end

end