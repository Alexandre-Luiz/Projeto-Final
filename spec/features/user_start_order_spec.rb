require 'rails_helper'

feature 'User starts a buy order' do
  scenario 'sucessfully' do
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
  end

  xscenario 'owner changes price of the product after order' do
    
  end

  xscenario 'product with an open order shouldnt be available in the search' do
    
  end
end