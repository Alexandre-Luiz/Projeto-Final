require 'rails_helper'

feature 'User seller suspends his announcement' do
  scenario 'sucessfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    click_on 'Ver detalhes'
    click_on 'Suspender anúncio'

    expect(current_path).to eq product_path(product)
    expect(product.reload).to be_suspended
    expect(page).to have_content('Anúncio suspenso com sucesso')
    #expect(page).to have_content('Este anúncio está suspenso. Caso queira reativá-lo, clique em habilitar anúncio')
  end

  scenario 'and can put it back' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: user, status: :suspended)

    login_as(user, scope: :user)
    visit product_path(product)
    click_on 'Habilitar anúncio'

    expect(current_path).to eq product_path(product)
    expect(product.reload).to be_enabled
    expect(page).to have_content('Anúncio habilitado com sucesso')
  end

  scenario 'suspended products cant be visible' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: user, status: :suspended)
    
    login_as(user, scope: :user)
    visit products_path

    expect(page).not_to have_content('Teclado')
    expect(page).not_to have_content('R$ 20,00')
    expect(page).not_to have_content('Vendedor: Fulano')
  end
end