require 'nokogiri'
require 'httparty'
require 'pry'
require 'telegram/bot'

TOKEN = '5208218361:AAGlBdoBtFYQwOGHMd1FAYIWfR4_Cs6SA90'

def call
  parsed_page
  adverts = Array.new
  page = 1
  while page <= last_page
    pagination_url = url + '%page=' + page.to_s
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page.body)
    pagination_adverts_listings = pagination_parsed_page.css('div.offer-wrapper')
    pagination_adverts_listings.each do |adverts_listing|
      advert = {
        title: adverts_listing.css('strong').text.strip.chomp, # title
        price: adverts_listing.css('p.price').text.strip.chomp, # price
        time_location: adverts_listing.css('td.bottom-cell').text.strip.chomp, # time_location
        url: adverts_listing.css('a')[0].attributes["href"].value # url
      }
      adverts << advert
    end
    page += 1
  end
  adverts
  # binding.pry
end

def last_page
  (total_count_adverts.to_f / per_page.to_f).floor
end

def url
  'https://www.olx.ua/uk/lv/q-google-pixel/?search%5Border%5D=created_at%3Adesc'
end

def unparsed_page
  HTTParty.get(url)
end

def parsed_page
  Nokogiri::HTML(unparsed_page.body)
end

def adverts_listings
  parsed_page.css('div.offer-wrapper')
end

def per_page  # 44 advert per page
  adverts_listings.count
end

def total_count_adverts
  parsed_page.css('li.visible').text.scan(/\d/).join('').to_i
end


Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      question = 'How many Pixels u want to check?'
      answers =
        Telegram::Bot::Types::ReplyKeyboardMarkup
          .new(keyboard: [%w[5 10], %w[20 100]], one_time_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    when '5'
      a = 0
      while a <5
        bot.api.send_message(chat_id: message.chat.id,
                             text: "#{call[a][:title]}\n \n \n Price: #{call[a][:price]} \n \n \n#{call[a][:url]} ")
        a += 1
      end
    when '10'
      a = 0
      while a < 10
        bot.api.send_message(chat_id: message.chat.id,
                             text: "#{call[a][:title]}\n \n \n Price: #{call[a][:price]} \n \n \n#{call[a][:url]} ")
        a += 1
      end
    when '20'
      a = 0
      while a < 20
        bot.api.send_message(chat_id: message.chat.id,
                             text: "#{call[a][:title]}\n \n \n Price: #{call[a][:price]} \n \n \n#{call[a][:url]} ")
        a += 1
      end
    when '100'
      a = 0
      while a < 1
        bot.api.send_message(chat_id: message.chat.id,
                             text: "#{call[a][:title]}\n \n \n Price: #{call[a][:price]} \n \n \n#{call[a][:url]} ")
        a += 1
      end
    end
  end
end

# Telegram::Bot::Client.run(TOKEN) do |bot|
#   bot.listen do |message|
#     case message.text
#     # when '/start'
#     #   bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
#     # when '/stop'
#     #   bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
#     # when '/pixel'
#     #   bot.api.send_message(chat_id: message.chat.id,
#     #                        text: "#{call[0][:title]} #{call[0][:url]} \n Price: #{call[0][:price]}")
#     when '/pixel5'
#       a = 0
#       while a <= 5
#         bot.api.send_message(chat_id: message.chat.id,
#                              text: "#{call[a][:title]}\n \n \n Price: #{call[a][:price]} \n \n \n#{call[a][:url]} ")
#         a += 1
#       end
#     end
#   end
# end





