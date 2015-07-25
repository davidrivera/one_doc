module OneDoc
  class RubyDocument < Document
    def initialize(target)
      @target = target
      parse
    end
  end
end
OneDoc.adapters.register OneDoc::RubyDocument do |target|
  (target.map &:downcase).include?('ruby')
end

