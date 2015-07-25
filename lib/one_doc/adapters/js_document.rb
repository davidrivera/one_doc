require 'json'
require 'digest'

module OneDoc
  class JsDocument < Document

    def initialize(target)
      super(target)
      parse
    end

    def parse
      # json = `jsdoc #{target} -t templates/haruki -d console -q format=json`
      output = `yuidoc #{@target}`

      file = File.read(@target + "/out/data.json")

      @raw = JSON.parse(file)
    end

    def export
      hash = {}
      hash[:files] = {
          :hash =>
      }
      hash
    end

    def files
      @raw.files.map! do |file|
        md5 = Digest::MD5.new
        md5.update File.read(@target+'/'+file.keys.first)
        file[:hash] = md5.hexdigest
      end
    end
  end
end

OneDoc.adapters.register OneDoc::PhpDocument do |target|
  (target.map &:downcase).include?('js')
end