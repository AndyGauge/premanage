require 'sinatra'
require './lib/import.rb'
require 'net/http'
require 'uri'
require 'json'

set :bind, '0.0.0.0'

get '/' do
  '<h1>PreManage CSV generator</h1> <h2>Create CSV and upload to premanage</h2> 
  <p>Upload a Valant facesheet report to create a CSV for PreManage</p>
  <form action="/" method="post" enctype="multipart/form-data"><div><input type="file" name="upload">
  Facility <input type="text" name="facility" value="'+params['id'].to_s+'"></div><div><input type="submit"></div></form>' 
end

post '/' do
  return "bad request" if params.nil?
  import = Import.new
  import.file = params['upload'][:tempfile]
  import.facility = params['facility']
  response.headers['Content-Type'] = 'text/csv'
  response.headers['Content-Disposition'] = "attachment;filename=premanage_eligibility_#{Time.new.strftime('%m-%d-%Y')}.csv"
  import.generate_pm_csv
end
