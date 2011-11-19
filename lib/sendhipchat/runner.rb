require 'optparse'
require 'hipchat-api'

module Sendhipchat
  trap(:INT) { puts; exit }

  class Runner
    YELLOW = 'yellow'
    RED    = 'red'
    GREEN  = 'green'
    PURPLE = 'purple'
    BLUE   = 'blue'

    attr_accessor :options

    def initialize(argv)
      @argv = argv
      @options = {
        :api_token => nil,
        :rooms     => [],
        :from      => nil,
        :notify    => false,
        :color     => YELLOW
      }

      parse!
    end

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = <<-EOS
Usage: sendhipchat [options]

Messages are read in from STDIN
        EOS
        opts.separator ''
        opts.on('-a TOKEN', '--api-token TOKEN', 'HipChat API token.') do |tk|
          @options[:api_token] = tk
        end
        opts.on('-f ALIAS', '--from ALIAS', 'Message "from".') do |f|
          if f.length > 15
            puts 'ERROR: from name must be <= 15 characters'
            puts
            puts @parser
            exit 1
          end
          @options[:from] = f
        end
        opts.on('--color COLOR', 'Message color: (yellow|red|blue|green|purple)') do |c|
          if color_valid?(c)
            @options[:color] = color_value(c)
          else
            puts 'ERROR: not a valid color choice'
            puts
            puts opts
            exit 1
          end
        end
        opts.on('--notify', 'Alert room members to message.') do
          @options[:notify] = true
        end
        opts.on('--rooms ROOMS', 'Comma separated room names.') do |rooms|
          @options[:rooms] = rooms.split(',').map { |r| r.strip }
        end
        opts.separator ''
        opts.on_tail('-h', '--help', 'Show this message.') do
          puts opts
          exit 0
        end
        opts.on_tail('-v', '--version', 'Show version') do
          puts Sendhipchat::VERSION; exit
        end
      end
    end

    def parse!
      parser.parse! @argv

      if @options[:api_token] == nil
        puts "ERROR: Must specify API token."
        puts
        puts @parser
        exit 1
      elsif @options[:from] == nil
        puts 'ERROR: Must provide a "from" alias.'
        puts
        puts @parser
        exit 1
      elsif @options[:rooms].empty?
        puts 'ERROR: Must specify at least one room.'
        puts
        puts @parser
        exit 1
      end
    end

    def run!
      hp = HipChat::API.new(@options[:api_token])

      rooms_to_id = rooms_flip(hp.rooms_list['rooms'])

      rooms = rooms_to_id.keys
      if !( (@options[:rooms] - rooms).empty? )
        puts 'ERROR: Only these rooms exist.'
        puts
        rooms.each do |r|
          puts r
        end
        puts
        puts @parser
        exit 1
      end

      msg = STDIN.read
      if msg.length > 5000
        puts 'ERROR: message must be <= 5000 characters'
        puts
        puts @parser
        exit 1
      end

      @options[:rooms].each do |r|
        hp.rooms_message(room_id=rooms_to_id[r], from=@options[:from],
          message=msg, notify=@options[:notify], color=@options[:color])
      end
    end

    private

    def rooms_flip(arr)
      rooms = {}
      arr.each do |h|
        rooms[h['name']] = h['room_id']
      end
      rooms
    end

    def color_valid?(color)
      ['yellow', 'red', 'green', 'purple', 'blue'].member?(color.downcase)
    end

    def color_value(color)
      { 'yellow'  => YELLOW,
        'red'    => RED,
        'green'  => GREEN,
        'purple' => PURPLE,
        'blue'   => BLUE}[color.downcase]
    end
  end
end
