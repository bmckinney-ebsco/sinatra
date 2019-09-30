# myapp.rb
require 'sinatra'
require 'ebsco/eds'

get '/' do
  'Hello world!'
end

get '/search' do
  erb(:search)
end

post '/search-action' do
  session = EBSCO::EDS::Session.new({:user=>'user', :pass=>'password', :profile=>'edsapi'})
  @query = params[:query]
  # @results = session.simple_search(@query)
  @results = session.search({query: @query, guest: false, view: 'detailed', results_per_page: 10, related_content: ['rs','emp']})
  erb(:results)
end

get '/details' do
  session = EBSCO::EDS::Session.new({:user=>'user', :pass=>'password', :profile=>'edsapi', :citation_styles_formats=>'mla,apa'})
  dbid = params[:dbid]
  an = params[:an]
  @record = session.retrieve({dbid: dbid, an: an})
  @apa_citation = session.get_citation_styles({dbid: dbid, an: an, format: 'apa'})
  erb(:details)
end