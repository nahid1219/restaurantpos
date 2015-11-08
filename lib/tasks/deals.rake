namespace :deals do
  desc "Populate Tables table with table numbers"
  task add: :environment do
    if Deal.all.count!=0
      Deal.delete_all
    end
    file_path="deals.xls"
    spreadsheet = Roo::Excel.new(file_path, nil, :ignore)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      deal = Deal.create! row.to_hash
    end
  end
end
