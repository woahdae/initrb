$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Initrb
  @pid = File.read(PIDFILE).to_i rescue nil

  def self.running?
    @pid && Process.kill(0, @pid)
  end

  def self.start
    if running?
      puts "already running (#{@pid})"
      exit
    end

    puts "starting #{NAME}"
    system("#{DAEMON} -c #{CONFIGFILE}")
  end

  def self.stop
    if not running?
      puts "not running"
      exit
    end

    pgid =  Process.getpgid(@pid)
    puts "stopping #{NAME}"
    Process.kill('-TERM', pgid)
  end

  def self.restart
    valid = system("#{DAEMON} -c #{CONFIGFILE} -t")
    if valid
      reload
      puts "if you meant to stop and start, do so manually"
    else
      puts "#{NAME} config file test failed"
    end
  end

  def self.reload
    puts "reloading #{NAME} configuration"
    Process.kill("-HUP", @pid)
  end

  def self.run(action = ARGV[0])
    case action
    when 'start'
      start
      exit
    when 'stop'
      stop
      exit
    when 'restart'
      restart
      exit
    when 'reload'
      reload
      exit
    when 'status'
      if running?
        puts "running (#{@pid})"
        exit
      else
        puts "not running"
        exit!(3)
      end
    else
      puts "Usage: #{SCRIPTNAME} start|stop|restart|reload|status"
    end
  end
end