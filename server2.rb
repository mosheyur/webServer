=begin
 implementation of a simple tcp web server 
 which can handle get and post request from client 
=end



require 'socket'

host = 'localhost'
port = 1355
web_server = TCPServer.new(host,port) # web_server object will listen to port 1355
public_folder_path = "Public"

http_response_message = {"status_line_ok"=>"HTTP/1.1 200 OK","status_line_not_found"=>"HTTP/1.1 404 Not Found", "Connection"=>"Connection: close\r\n", "Content-Type"=>"","Content-Length"=>"","empty_line"=>"\r\n" }
p http_response_message
content_type = {html: "text/html", txt: "text/plain"}


# start an infinite loop

loop do
  Thread.start(web_server.accept) do |tcp_socket| # wait for a client to request connection and start a thread
  request_from_client = tcp_socket.gets # read the clients request 
  puts request_from_client
  # check if it is a get request or post request
  if /\S+/.match(request_from_client).to_s == "GET"

  url_from_client = /\s\S+\s/.match(request_from_client).to_s.strip
  # if no path exists use default path as /index.html
  p url_from_client
  if url_from_client == "/" 
    url_from_client = "/index.html"
  end
  p url_from_client
  # find the extention of the file and determine the Content-type field
  file_extension = url_from_client.split(".").last.to_sym
  p file_extension
  if file_extension
  http_response_message["Content-Type"] = content_type[file_extension]
  end
  p http_response_message 
  # find if the file exists in the directory
  if File.exist?(public_folder_path+url_from_client)
    p "file found"
    
      tcp_socket.print "HTTP/1.1 200 OK\r\n"+
                        "Connection: close\r\n"+
                        "Content-Type: #{content_type[file_extension]}\r\n"+
                        "\r\n" 
                        
       File.open(public_folder_path+url_from_client).each do |line|
    
      tcp_socket.print line  
      # puts line
      
    end
  else
    tcp_socket.print "HTTP/1.1 404 Not Found\r\n"+
                        "Connection: close\r\n"+
                        "\r\n"
    tcp_socket.puts "404 ERROR!"
      
    
  end
  tcp_socket.close
  else 
     # code for post request here

    puts "reading from the socket"
    content_length_to_read = 0
    loop do
      # s = tcp_socket.gets
      header = tcp_socket.gets
      p header
      if header=="\r\n"
        break
      end
      if content_length_header = /Content-Length:/.match(header)
        content_length_to_read = content_length_header.post_match.to_i
        
      end
      puts "content length #{content_length_to_read}"
    end
    post_request_info = tcp_socket.read(content_length_to_read)
    p post_request_info
    #puts "closing connection"
    user_name = post_request_info.split("=").last.strip
    
    tcp_socket.print "HTTP/1.1 200 OK\r\n"+
                        "Connection: close\r\n"+
                        "Content-Type: text/html\r\n"+
                        "\r\n"
                        
     tcp_socket.print "your user name is #{user_name.gsub("+"," ")}"                   
                       
    #tcp_socket.puts post_request_info
     tcp_socket.close
   
    
    
  end
  end
  
end

