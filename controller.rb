# buzzer | byte  | value | bit
# 1      |  2    |  1    |  0
# 2      |  2    |  32   |  5
# 3      |  3    |  4    |  2
# 4      |  3    |  128  |  7

class Controller

  BUZZ_BYTES = [
    [2, 0],
    [2, 5],
    [3, 2],
    [3, 7]
  ]

  def initialize
    @usb_context = LIBUSB::Context.new
    @device = @usb_context.devices(
      idVendor: 0x054c, idProduct: 0x0002
    ).first
    reset_device_access
    @handle = @device.open
  end

  def raw_data
    data = @handle.bulk_transfer(
      :endpoint => 0x81,
      :dataIn => 0x0005,
      :timeout => 10
    )
    data.bytes
  end

  def reset_device_access
    device = @usb_context.devices(
      idVendor: 0x054c, idProduct: 0x0002
    ).first
    handle = device.open
    handle.detach_kernel_driver(0)
    handle.close
  rescue => er
    puts er.message
    # nothing needs doing here
  end

  def check
    data = raw_data
    BUZZ_BYTES.each_with_index do |lookup, i|
      if data[lookup[0]][lookup[1]] == 1
        puts "buzzer #{i + 1} pushed"
        # action_on_buzzer(i)
      end
    end
  rescue
    # no input, just ignore the error
  end

end