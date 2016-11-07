class Import
  require 'csv'
  attr_accessor :contents
  attr_accessor :file

  def file=(file_param)
    @file=file_param
    @contents=CSV.read(file_param, :headers => true)
  end

  def facility=(facility_id)
    @facility = facility_id
  end

  def generate_pm_csv
    if contents && @facility
      pm_csv = CSV.generate do |csv|
        csv << pm_fields
        contents.each do |r|
          row = []
          pm_fields.each do |f|
            row << self.send("pm_#{f.downcase}", r)
          end
          (csv << row) unless row[0].empty? || row[1].empty?
        end
      end
      pm_csv
    end
  end

  def pm_fields
    %w(MRN SSN Address Address2 City State Zip DOB Gender Home First Last Facility)
  end

  private
  def pm_mrn(row)
    #mrn is 'PatientId' but the CSV has some binary digit that adjust length by 1 but does not display
    row[row.headers[0]]
  end

  def pm_address(row)
    row['Street1']
  end

  def pm_address2(row)
    row['Street2']
  end

  def pm_city(row)
    row['City']
  end

  def pm_state(row)
    row['State']
  end

  def pm_zip(row)
    row['ZipCode'].to_s.gsub(/[^0-9]/,'')
  end

  def pm_ssn(row)
    row['SSN'].to_s.gsub(/[^0-9]/,'')
  end

  def pm_dob(row)
    row['Birthdate']
  end

  def pm_gender(row)
    row['Sex'][0].upcase
  end

  def pm_home(row)
    (row['MainPhone'] || row['HomePhone']).to_s.gsub(/[^0-9]/,'')
  end

  def pm_first(row)
    row['FirstName']
  end

  def pm_last(row)
    row['LastName']
  end

  def pm_facility(row)
    @facility
  end
end
