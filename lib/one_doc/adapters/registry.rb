module OneDoc
  class AdapterRegistry

    attr_reader :registered_handlers

    def initialize
      @registered_handlers = []
    end

    def register(handler_class, &block)
      @registered_handlers << [block, handler_class]
    end

    def handler_for(target)
      @registered_handlers.each do |tester, handler|
        return handler if tester.call(target)
      end
    end

    def registered?(target)
      @registered_handlers.any? do |tester, handler|
        handler === target
      end
    end

    def for(target, dir)
      handler_for(target).new(dir)
    end
  end
end