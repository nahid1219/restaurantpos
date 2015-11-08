namespace :tables do
  desc "Populate Tables table with table numbers"
  task add: :environment do
     if Table.all.count==0
       (1..4).each do |n|
         Table.create nmr: n
       end
     else
       Table.delete_all
     end
  end
end
