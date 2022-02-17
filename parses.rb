require 'nokogiri'
require 'httparty'
require 'pry'

def call
  parsed_page
  adverts = Array.new
  page = 1
  while page <= last_page
    pagination_url = url + '%page=' + page.to_s
    adverts_listings.each do |adverts_listing|
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
  binding.pry
end

def last_page
  (total_count_adverts.to_f / per_page.to_f).round
end

def url
  'https://www.olx.ua/uk/lv/q-google-pixel/?search%5Border%5D=created_at%3Adesc'
end

def unparsed_page
  HTTParty.get(url)
end

def parsed_page
  Nokogiri::HTML(unparsed_page)
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

call
