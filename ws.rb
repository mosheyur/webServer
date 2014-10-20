=begin
 implementation of a simple tcp web server 
 which can handle get and post request from client 
=end



require 'socket'

host = 'sharafat'
port = 8080
client = TCPSocket.open(host,port) # web_server object will listen to port 1355
loop do

puts client.readlines

end