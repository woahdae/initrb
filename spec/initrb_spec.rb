require File.dirname(__FILE__) + '/spec_helper.rb'

PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"
DESC="nginx daemon"
NAME="nginx"
DAEMON="/usr/local/sbin/#{NAME}"
CONFIGFILE="/etc/nginx/nginx.conf"
PIDFILE="/var/run/#{NAME}.pid"
SCRIPTNAME="/etc/init.d/#{NAME}"

describe Initrb do
  before(:each) do
    # make sure exit is never actually called.
    # We can still make expectations about this later, if appropriate.
    Initrb.stub!(:exit)
    Initrb.stub!(:exit!)
  end
  
  describe "self.run" do
    it "should call start on start" do
      Initrb.should_receive(:start)
      Initrb.should_receive(:exit)
      Initrb.run("start")
    end
    
    it "should call stop on stop" do
      Initrb.should_receive(:stop)
      Initrb.should_receive(:exit)
      Initrb.run("start")
    end
    
  end
  
end
