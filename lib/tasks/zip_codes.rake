# Write all of the zip codes from the USPS website to the database so we can have some validation
# its very possible that not all of the zip codes are in the file
# https://postalpro.usps.com/ZIP_Locale_Detail
namespace :zip_codes do
  desc "Write all of the zip codes to the database so we can use it in validation"
  task load_zip_codes: :environment do
    zip_codes = File.readlines("db/zip_codes.txt").map(&:strip).uniq

    zip_codes.each do |code|
      ZipCode.create(code: code) unless ZipCode.exists?(code: code)
    end

    puts "Total of #{zip_codes.count} zip codes loaded into the database."
  end
end
