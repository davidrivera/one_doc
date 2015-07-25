module OneDoc
  class Parser
    def initialize(dir)
      @dir = dir

      @repo = Rugged::Repository.new(@dir)

    end

    def parse
      project = Linguist::Repository.new(@repo, @repo.head.target_id)
      langs = project.languages.keys

      OneDoc.adapters.for(langs, @dir)
    end
  end
end