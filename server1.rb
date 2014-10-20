require 'socket'
server = TCPServer.new 1355 # bind the server to the port 1355
loop do
  client = server.accept # wait for a client to connect
  a = client.gets
  puts a 
  client.puts "Hello ! How are you?"
  client.puts "The time is #{Time.now}"
  client.puts "once in a golden hour i cast to earth a seed\nfrom there came a flower and people called it but a weed"
  client.close
  
 end
