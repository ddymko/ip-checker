require 'open-uri'
require 'nexmo'
require 'dotenv/load'

remote_ip = open('http://whatismyip.akamai.com').read
client = Nexmo::Client.new(api_key: ENV['NEXMO_KEY'], api_secret: ENV['NEXMO_SECRET'])

if File.exists?("ip_address.txt")

  if File.readlines("ip_address.txt").any? {|l| l[remote_ip]}
    puts "It was inside!"
  else
    File.open("ip_address.txt", "w+") {|f| f.write(remote_ip)}
    client.sms.send(
        from: ENV['FROM_NUMBER'],
        to: ENV['TO_NUMBER'],
        text: "IP Address #{remote_ip}"
    )
  end

else
  File.open("ip_address.txt", "w+") {|f| f.write(remote_ip)}
  client.sms.send(
      from: ENV['FROM_NUMBER'],
      to: ENV['TO_NUMBER'],
      text: "IP Address #{remote_ip}"
  )
end


puts remote_ip
