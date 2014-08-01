require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
 
get '/hello-monkey' do
  people = {
    '+447838828838' => 'Josef',
    '+447769331030' => 'Georgi Boy',
    '+14158675311' => 'Virgil',
    '+14158675312' => 'Marcel',

  }
  name = people[params['From']] || 'Unregistered DoPay Member'
  Twilio::TwiML::Response.new do |r|
    r.Say "Hello #{name}"
    r.Play 'http://demo.twilio.com/hellomonkey/monkey.mp3'
    r.Gather :numDigits => '1', :action => '/hello-monkey/handle-gather', :method => 'get' do |g|
	    g.Say 'To speak to customer service, please press 1.'
	    g.Say 'Press 2 to leave a message.'
	    g.Say 'Press any other key to start over.'
    end
  end.text
end

get '/hello-monkey/handle-gather' do
  redirect '/hello-monkey' unless ['1', '2'].include?(params['Digits'])
  if params['Digits'] == '1'
  	response = Twilio::TwiML::Response.new do |r|
    r.Dial '+447704210173' ### Connect the caller to Koko, or your cell
    r.Say 'The call failed or the remote party hung up. Goodbye.'
    end
  elsif params['Digits'] == '2'
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Record your monkey howl after the tone.'
      r.Record :maxLength => '30', :action => '/hello-monkey/handle-record', :method => 'get'
    end
  end
  response.text
end


get '/sms-quickstart' do
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message "Hey dude. Thanks for the message!"
  end
  twiml.text
end

