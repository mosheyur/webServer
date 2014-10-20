=begin
 implementation of a simple tcp web server 
 which can handle get and post request from client 
=end



require 'socket'

host = 'localhost'
port = 8080
web_server = TCPServer.new(host,port) # web_server object will listen to port 1355