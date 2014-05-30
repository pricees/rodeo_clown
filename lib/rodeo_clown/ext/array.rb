#
# Wait fo
#
class Array

  def wait_for_state(state)
    wait_for_attr_state(:state, :available)
  end

  def wait_for_attr_state(attr, state, time = 1)
    until all? { |el| el.send(attr) == state }
      print "."
      sleep time
    end

    self
  end
end
