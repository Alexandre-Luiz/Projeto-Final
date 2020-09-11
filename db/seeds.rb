# Usuários de empresas diferentes
# Usuários e produtos empresa 1
user = User.create!(name: 'Gabriel', password: '123456789', 
                    email: 'gabriel@google.com', role: 'Estagiário',
                    department: 'Recursos humanos')
user_2 = User.create!(name: 'Rafael', password: '123456789', 
                      email: 'rafael@google.com', role: 'Diretor',
                      department: 'Financeiro')
user_3 = User.create!(name: 'Felipe', password: '123456789', 
                      email: 'felipe@google.com', role: 'Gerente',
                      department: 'marketing')

product = Product.create!(name: 'Placa de vídeo GTX 970', category: 'Eletrônicos', 
                          description: 'Funcionando perfeitamente', price: '1000', 
                          user: user, status: :enabled)

product_2 = Product.create!(name: 'Bola oficial copa 2014', category: 'Esporte', 
                            description: 'Nunca foi usada', price: '2000', 
                            user: user, status: :enabled)
product_2.image.attach(io: File.open(Rails.root.join('spec/support/bola.png')), filename: 'bola.png')

product_3 = Product.create!(name: 'Monitor Samsung 24 polegadas', category: 'Eletrônicos', 
                            description: 'Um ano de uso. Não apresenta nenhum defeito', price: '1000', 
                            user: user_2, status: :enabled)

product_4 = Product.create!(name: 'Jaqueta de couro legítimo', category: 'Roupas e vestuário', 
                            description: 'Comprei, mas não serviu. Nunca foi usada', price: '400', 
                            user: user_3, status: :enabled)

Question.create!(content: 'É autografada pelo Neymar?', user: user_3, product: product_2)
Question.create!(content: 'Qual o tamanho? Serve em alguem de 2,20?', user: user, product: product_4)


# Usuários e produtos empresa 2
user_4 = User.create!(name: 'João', password: '123456789', 
                      email: 'João@facebook.com', role: 'Estagiário',
                      department: 'Segurança da informação')
user_5 = User.create!(name: 'Paula', password: '123456789', 
                      email: 'Paula@facebook.com', role: 'Analista',
                      department: 'Financeiro')
user_6 = User.create!(name: 'Isabella', password: '123456789', 
                      email: 'Isabella@facebook.com', role: 'Gerente',
                      department: 'Criptografia')

product_5 = Product.create!(name: 'MacBook pro 16 polegadas', category: 'Eletrônicos', 
                            description: 'Intel Core i9 de oito núcleos e 2,4 GHz (Turbo Boost até 5,0 GHz) com cache L3 compartilhado de 16 MB', 
                            price: '10000', user: user_4, status: :enabled)
                            
product_6 = Product.create!(name: 'Iphone 7', category: 'Eletrônicos', 
                            description: 'Está impecável. Sem nenhum risco na tela e na parte de trás', 
                            price: '3000', user: user_5, status: :enabled)
product_6.image.attach(io: File.open(Rails.root.join('spec/support/iphone.png')), filename: 'iphone.png')

product_6 = Product.create!(name: 'Playstation 4', category: 'Brinquedos e games', 
                            description: 'Acompanha 10 jogos originais.', 
                            price: '3000', user: user_5, status: :enabled)
                          
product_7 = Product.create!(name: 'Atari', category: 'Brinquedos e games ', 
                            description: 'Muito bem conservado', 
                            price: 5000, user: user_6, status: :enabled)
product_7.image.attach(io: File.open(Rails.root.join('spec/support/atari.png')), filename: 'atari.png')

Question.create!(content: 'Vem com mais de um controle?', user: user_6, product: product_6)
Question.create!(content: 'É banhado a ouro?', user: user_5, product: product_5)