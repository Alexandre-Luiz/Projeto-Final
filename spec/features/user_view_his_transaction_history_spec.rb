require 'rails_helper'

feature 'User view his operations' do
  scenario 'regarding his announcements - successfully' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com',role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com', role: 'Estagiário',
                                department: 'Marketing')
    product = Product.create!(name: 'Teclado mecânico Logitech', category: 'Eletrônicos', 
                              description: 'Teclado com pouquíssimo uso. Possui RGB', 
                              price: 200, user: user, status: :disabled)
    another_product = Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                                      description: 'Bola oficial da copa 2014. Nunca foi usada', 
                                      price: 500, user: user, status: :disabled)
    another_another_product = Product.create!(name: 'PS4', category: 'Brinquedos e games', 
                                              description: 'Está em perfeitas condições. Acompanha dois jogos.', 
                                              price: 3000, user: user, status: :disabled)
    product_4 = Product.create!(name: 'Atari', category: 'Brinquedos e games ', 
                                      description: 'Muito bem conservado', 
                                      price: 5000, user: another_user, status: :disabled)
    order = Order.create!(discount: 100, payment_method: 'Dinheiro', address: 'Rua do matão, 100',
                          comment: 'Desconto que combinamos no almoço', user: another_user, product: product, status: :in_progress)
    another_order = Order.create!(discount: 200, payment_method: 'Transferência bancária', address: 'Av. Paulista, 100',
                                  comment: 'Tudo que posso pagar', user: another_user, product: another_product, status: :completed)
    another_another_order = Order.create!(discount: 500, payment_method: 'Dinheiro', address: 'Rua Verediana, 100',
                                          comment: 'É para o aniversário do meu filho. Ele é o próximo neymar', 
                                          user: another_user, product: another_another_product, status: :canceled)
    order_4 = Order.create!(discount: 500, payment_method: 'Dinheiro', address: 'Rua Buenos Aires, 100',
                                          comment: 'Sou colecionador, gostei das condições.', 
                                          user: user, product: product_4, status: :completed)


    login_as(user, scope: :user)
    visit root_path
    click_on 'Perfil'
    click_on 'Histórico de transações'

    expect(page).to have_content('Bola de futebol')
    expect(page).to have_content('PS4')
    expect(page).to have_content('Atari')
    # Pedido ainda não foi analisado e não pode aparecer no histórico
    expect(page).not_to have_content('Teclado mecânico Logitech') 
  end

  scenario 'Only the seller or buyer can acess the finished order' do
    user = User.create!(name: 'Fernando', password: '123456789', email: 'fernando@test.com',role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Rafael', password: '123456789', email: 'rafael@test2.com', role: 'Estagiário',
                                department: 'Marketing')
    another_another_user = User.create!(name: 'Pedro', password: '123456789', email: 'pedro@test2.com', role: 'Estagiário',
                                        department: 'Financeiro')
    product = Product.create!(name: 'Bola de futebol', category: 'Esporte', 
                              description: 'Bola oficial da copa 2014. Nunca foi usada', 
                              price: 500, user: another_another_user, status: :disabled)
    order = Order.create!(discount: 200, payment_method: 'Transferência bancária', address: 'Av. Paulista, 100',
                          comment: 'Tudo que posso pagar', user: another_user, product: product, status: :completed)

    login_as(user, scope: :user)
    visit product_order_path(product, order)

    expect(current_path).to eq products_path
  end
end