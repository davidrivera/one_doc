module OneDoc
  class DataStructure


    def initialize(type, doc)
      @type = type
      @doc = doc
    end

    def add_member(member)
      @members << member
    end
  end
end