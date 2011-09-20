require 'yaml'

namespace :region do

  desc "Import region data to database from config/regions.yml"
  task :import => :environment do
    file_path = File.join(Rails.root, 'config', 'regions.yml')
    regions = File.open(file_path) { |file| YAML.load(file) }
    load_to_db(regions)
    puts "Regions import done!"
  end
  
  desc "Test"
  task :abc do 
    puts "1111111111111"
  end

  def load_to_db(regions)
    regions.each do |province_name, province_hash|
      current_province = Province.create(:name => province_name, :pinyin => province_hash['pinyin'], :pinyin_abbr => province_hash['pinyin_abbr'])
      cities_hash = province_hash['cities']
      cities_hash.each do |city_name, city_hash|
        current_city = current_province.cities.create(:name => city_name, :pinyin => city_hash['pinyin'], :pinyin_abbr => city_hash['pinyin_abbr'], :zip_code => city_hash['zip_code'], 'level' => city_hash['level'] || 4)
        districts_hash = city_hash['districts']
        districts_hash.each do |district_name, district_hash|
          current_city.districts.create(:name => district_name, :pinyin => district_hash['pinyin'], :pinyin_abbr => district_hash['pinyin_abbr'])
        end
      end
    end
  end

end