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

      hash[:files] = files

      hash
    end

    def files
      @raw['files'].keys.map do |key|
        file = @raw['files'][key]
        md5 = Digest::MD5.new
        md5.update File.read(@target+'/'+file['name'])
       a = {
           :hash => md5.hexdigest,
           :name => file['name'],
           :doc => '',
           # :classes => classes_for(file),
        }

        if has_classes(file)
          a[:data] << new_classes(file)
        end

        # if has_traits(file)
        #   a[:data] << new_traits(file)
        # end

        a
      end
    end

    def has_classes(file)
      file['classes'].keys.any?
    end

    def new_classes(file)
      file['classes'].keys.each do |c|
        klass = @raw['classes'][c]
        a = {
            :structure => 'class',
            :name => klass['name'],
            :doc => klass['description'],
            :members => []
        }

        new_functions(klass, a)

        new_properties(klass, a)

        a
      end
    end

    def new_functions(klass, hash)
      @raw['classitems'].collect{|obj| obj.has_value?(klass['file']) && obj.has_value?('method')}.each do |item|
        hash[:members] << {
          :type => 'function',
          :value => {
              :doc => item['description'],
              :params => item['params'],
              :visibility => item['access'],
              :line => item['line'],
              :name => item['name']
          }
        }
      end
    end

    def classes_for(file)
      # file[1]['classes'].keys.map do |klass|
      #   klass_def = @raw['classes'][klass]
      #   {
      #       :doc => klass_def['description']
      #       :name => name_for(klass),
      #       :extends => klass.xpath('./extends').text,
      #       :final => klass.attribute('final').value,
      #       :abstract => klass.attribute('abstract').value,
      #       :line => klass.attribute('line').value,
      #       :functions => functions(klass),
      #       :properties => properties_for(klass)
      #   }
      # end
    end
  end
end

OneDoc.adapters.register OneDoc::PhpDocument do |target|
  (target.map &:downcase).include?('js')
end