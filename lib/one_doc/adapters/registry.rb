module OneDoc
  class AdapterRegistry

    attr_reader :registered_handlers

    def initialize
      @registered_handlers = []
    end

    def register(handler_class, &block)
      @registered_handlers << [block, handler_class]
    end

    # TODO: refactor
    def handlers_for(target)
      handler = @registered_handlers.select do |tester, handler|
        tester.call(target)
      end

      handler.map &:last
    end

    def registered?(target)
      @registered_handlers.any? do |tester, handler|
        handler === target
      end
    end

    def for(target, dir)
      handlers_for(target).map do |handler|
        handler.new(dir)
      end
    end
  end
end