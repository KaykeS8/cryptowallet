namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD") { %x(rails db:drop) }
      show_spinner("Criando BD") { %x(rails db:create) }
      show_spinner("Migrando BD") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts "Voce nao esta em ambiente de desenvolvimento"
      spinner.error("error")
    end
  end

  desc "cadastra as moedas"
  task add_coins: :environment do 
    show_spinner("Cadastrando moedas...") do
      coins = [
        {
          description: 'etherum',
          acronym: 'ETH',
          url_image: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
          mining_type: MiningType.all.sample
        },
        {
          description: 'Bitcoin',
          acronym: 'BTC',
          url_image: 'https://www.freeiconspng.com/thumbs/bitcoin-icon-png/black-bitcoin-icon-6.png',
          mining_type: MiningType.find_by(acronym: 'PoW')
        },
        {
          description: 'Dash',
          acronym: 'Dash',
          url_image: 'https://s2.coinmarketcap.com/static/img/coins/200x200/131.png',
          mining_type: MiningType.all.sample
        }
      ]
      
      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end

    end
  end 

  desc "cadastra os tipos de mineração"
  task add_mining_types: :environment do 
    show_spinner('Cadastrando tipos') do 
      mining_types = [
        {description: 'Proof of Work', acronym: 'PoW'},
        {description: 'Proof of Stake', acronym: 'PoS'},
        {description: 'Proof of Capicty', acronym: 'PoC'}
      ]
      
      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end


  private
  def show_spinner(message_start, message_end = 'Concluido com sucesso')
    spinner = TTY::Spinner.new("[:spinner] #{message_start} ...")
    spinner.auto_spin
    yield
    spinner.success(message_end)
  end

end