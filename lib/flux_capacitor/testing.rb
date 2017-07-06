module Flux
  class Falsey < Capacitor
    def initialize(*args)
      @pivot = DateTime.now
      @time_dilation = 2.0
    end

    def travel_to?(point)
      false
    end
  end

  class Truethy < Capacitor
    def initialize(*args)
      @pivot = DateTime.now
      @time_dilation = 2.0
    end

    def travel_to?(point)
      true
    end
  end
end