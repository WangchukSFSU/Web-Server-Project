require 'socket'
require 'Request'


class SimpleClient
  attr_reader :options

  DEFAULT_PORT = 56789

  def initialize(options={})
    @options = options
  end

  def perform_requests()
   
      socket = TCPSocket.open('localhost', DEFAULT_PORT)
      
       puts "Pass request to socket}:"
       socket.print(Request.new("requestStream").parse)

      puts "Read response from socket}:"
      while line = socket.gets
        puts line.chop

      end

      socket.close
      puts "Closed request"
    end

  end
