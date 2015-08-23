require 'libusb'
load './controller.rb'

c = Controller.new

loop do
  begin
    c.check
  rescue
  end
  sleep 0.01
end