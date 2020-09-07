require 'rails_helper'

feature 'User seller finishes order open on his product' do
  scenario '- Accept successfully' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com',role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com', role: 'Estagiário',
                                department: 'Marketing')
    product = Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                              description: 'Teclado com pouquíssimo uso. Possui RGB', 
                              price: 200, user: user, status: :disabled)
    order = Order.create!(discount: 100, payment_method: 'Dinheiro', address: 'Rua do matão, 100',
                          comment: 'Desconto que combinamos no almoço', user: another_user, product: product, status: :in_progress)
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Meus produtos'
    find_link('Analisar', href: product_my_order_path(product.id)).click
    click_on 'Aceitar'

    expect(order.reload).to be_completed
    expect(product.reload).to be_disabled
    expect(current_path).to eq user_path(user)
    expect(page).to have_content('Venda finalizada com sucesso!')
  end

  scenario '- Declines sucessfully' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com',role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com', role: 'Estagiário',
                                department: 'Marketing')
    product = Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                              description: 'Teclado com pouquíssimo uso. Possui RGB', 
                              price: 200, user: user, status: :disabled)
    order = Order.create!(discount: 100, payment_method: 'Dinheiro', address: 'Rua do matão, 100',
                          comment: 'Desconto que combinamos no almoço', user: another_user, product: product, status: :in_progress)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Meus produtos'
    find_link('Analisar', href: product_my_order_path(product.id)).click
    click_on 'Recusar'

    expect(order.reload).to be_canceled
    expect(product.reload).to be_enabled
    expect(current_path).to eq user_path(user)
    expect(page).to have_content('Oferta negada com sucesso. Seu produto está disponível para compra novamente.')
  end

  scenario 'and after accept it, the product does not appear in his listing' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com',role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com', role: 'Estagiário',
                                department: 'Marketing')
    product = Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                              description: 'Teclado com pouquíssimo uso. Possui RGB', 
                              price: 200, user: user, status: :disabled)
    another_product = Product.create!(name: 'Atari', category: 'Brinquedos e games ', 
                              description: 'Muito bem conservado', 
                              price: 5000, user: user, status: :enabled)

    order = Order.create!(discount: 100, payment_method: 'Dinheiro', address: 'Rua do matão, 100',
                          comment: 'Desconto que combinamos no almoço', user: another_user, product: product, status: :in_progress)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Meus produtos'
    find_link('Analisar', href: product_my_order_path(product.id)).click
    click_on 'Aceitar'
    click_on 'Meus produtos'

    order.reload
    product.reload
  
    expect(page).not_to have_content('Teclado mecânico Logitech')
    expect(page).to have_content('Atari')
    expect(page).to have_link('Detalhes')
  end
end