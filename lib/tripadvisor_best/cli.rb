class TripAdvisorBest::CLI
  attr_reader :sites

  def initialize
    @sites = [
      {class_name: TripAdvisorBest::Museum, url: "https://www.tripadvisor.com/TravelersChoice-Museums#1"},
      {class_name: TripAdvisorBest::Attraction, url: "https://www.tripadvisor.com/TravelersChoice-Attractions"},
      {class_name: TripAdvisorBest::Landmark, url: "https://www.tripadvisor.com/TravelersChoice-Landmarks"}
    ]
    make_highlights
    add_highlight_details
  end

  def make_highlights
    puts "Planning your next big trip..."
    self.sites.each do |site|
      highlights_array = []
      highlights_array = TripAdvisorBest::Scraper.new.scrape_listings_page(site[:url])
      site[:class_name].create_from_collection(objects_array)
    end
  end

  def add_highlight_details
    puts "It's gonna be great!"
    self.sites.each do |site|
      site[:class_name].all.each do |highlight|
        attributes = TripAdvisorBest::Scraper.new.scrap_details_page(highlight.url)
        highlight.add_highlight_attributes(attributes)
      end
    end
  end

  def call
    welcome
    menu
  end

  def welcome
    puts "The TripAdvisor Traveler's Choice Awards are out."
    puts "Are you ready to travel the world?"
    puts "  (Type 'exit' to leave program.)"
  end

  def menu
    input = nil
    while input != "exit"
      list_options
      input = gets.strip.downcase
      case input
      when "1"
        puts "Here are the top 25 Museums in the world..."
        list_hightlights(sites[0][:class_name])
      when "2"
        puts "Here are the top 25 Attractions in the world..."
        list_hightlights(sites[1][:class_name])
      when "3"
        puts "Here are the top 25 Landmarks in the world..."
        list_hightlights(sites[2][:class_name])
      when "list"
        list_options
      when "exit"
        goodbye
      else
        puts "I'm not sure what you want. Either type 'list' or 'exit'."
      end
    end
  end

  def list_options
    puts "Currently you can see..."
    puts <<-DOC
      1. Top 25 Museums
      2. Top 25 Attractions
      3. Top 25 Landmarks
    DOC
    puts "Which would you like to see?"
  end

  def goodbye
    puts "Bon voyage!"
  end

  def make_highlights
    puts "Planning your next big trip..."
    self.sites.each do |site|
      highlights_array = []
      highlights_array = TripAdvisorBest::Scraper.new.scrape_listings_page(site[:url])
      site[:class_name].create_from_collection(highlights_array)
    end
  end

  def list_hightlights(class_name)
    class_name.all.each do |highlight|
      puts "#{highlight.ranking}. - #{highlight.name}".colorize(:yellow)
    end
  end
end
