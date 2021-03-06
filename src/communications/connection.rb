require 'singleton'
require 'socket'

require 'server_process_not_found'

java_import java.lang.ProcessBuilder
java_import com.drogar.lqpl.Main
java_import java.net.URLDecoder

# base for creating a connection
class Connection
  include Singleton

  LOCAL_CONNECTS = ['127.0.0.1', '::1', 'localhost'].freeze
  attr_accessor :port, :connect_to
  attr_reader :connection

  def initialize(port = nil)
    @port = port
    @connection = nil
    @process = nil
  end

  def connected?
    !connection.nil?
  end

  def close_down
    connection&.close
    @process&.destroy
    @connection = nil
    @process = nil
  end

  def self.get_instance(port = nil)
    c = instance
    c.port = port
    c
  end

  def connection_list
    # TODO: - add flag to pick order of these.
    [connect_to, "#{my_path}bin/#{connect_to}", "#{my_path}../out/bin/#{connect_to}"]
  end

  def no_process_error
    "There was no process found on port #{@port}. Please start '#{@connect_to}'."
  end

  def connect
    errors = make_connection
    return if errors.empty?

    errors = connect_to_connection_list
    raise ServerProcessNotFound, no_process_error unless errors.empty?
  end

  def connect_to_connection_list
    errors = []
    connection_list.each do |location|
      errors = try_connecting_to location
      break if errors.empty?
    end
    errors
  end

  def try_connecting_to(location)
    begin
      _start_up_the_executable_in_a_process(location)
    rescue StandardError
      return ["Unable to connect to #{location}"]
    end
    []
  end

  def send_data(command)
    connection.puts(command)
  end

  def send_and_read_data(command)
    connect unless connected?
    send_data command
    read_data
  end

  def read_data
    connection.readline
  end

  def make_connection
    LOCAL_CONNECTS.each do |addr|
      @connection = TCPSocket.new addr, @port
      return []
    rescue Errno::ECONNREFUSED => e
      return ["Connect refused For #{addr}, exception: #{e}"]
    rescue SocketError => e
      return ["Socket error for  #{addr}, exception: #{e} "]
    end
  end

  def my_path
    return @my_path if @my_path

    resolver = Monkeybars::Resolver.new(location: __FILE__)
    @my_path ||= "#{resolver.bare_path}/../../"
  end

  private

  def _start_up_the_executable_in_a_process(executable)
    @process = ProcessBuilder.new(executable, '').start
    sleep 0.25
    res2 = make_connection
    raise ServerProcessNotFound unless res2.empty
  end
end
