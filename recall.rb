require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/provider.db")
 
class Appointment 
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true
  property :gender, Text, :required => true, :default => 'M'
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end
 
DataMapper.finalize.auto_upgrade!



get '/' do
  @appointments= Appointment.all :order => :id.desc
  @title = 'All Appointments'
  erb :home
end

post '/' do
  n = Appointment.new
  n.content = params[:content]
  n.name = params[:name]
  n.gender = params[:gender]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id' do
  @appointments= Appointment.get params[:id]
  @title = "Edit appointment ##{params[:id]}"
  erb :edit
end

put '/:id' do
  n = Appointment.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/delete' do
  @appointments= Appointment.get params[:id]
  @title = "Confirm deletion of Appointment  ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  n = Appointment.get params[:id]
  n.destroy
  redirect '/'
end

get '/:id/complete' do
  n = Appointment.get params[:id]
  n.complete = n.complete ? 0 : 1 # flip it
  n.updated_at = Time.now
  n.save
  redirect '/'
end

