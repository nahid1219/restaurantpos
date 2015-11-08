class Detail < ActiveRecord::Base
  validates_presence_of :name,:city,:phone1,:phone2,:address,:email
end
