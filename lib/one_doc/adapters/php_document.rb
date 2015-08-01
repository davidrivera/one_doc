module OneDoc
  class PhpDocument < Document

    def initialize(target)
      @target = target
      parse
    end

    def parse
      output_dir = @target + "_ouput"
      output = `phpdoc run -d #{@target} -t /tmp/#{output_dir} --template=xml`

      @xml_doc  = Nokogiri::XML(File.open("/tmp/#{output_dir}/structure.xml"))
    end

    def classes(node)
      node.xpath('./class').map do |klass|
        {
            :doc => docblock_for(klass),
            :name => name_for(klass),
            :extends => klass.xpath('./extends').text,
            :final => klass.attribute('final').value,
            :abstract => klass.attribute('abstract').value,
            :line => klass.attribute('line').value,
            :functions => functions(klass),
            :properties => properties_for(klass)
        }
      end
    end

    def new_classes(node)
      node.xpath('./class').map do |klass|
        a = {
            :structure => 'class',
            :name => name_for(klass),
            :doc => docblock_for(klass),
            :members => [
                {
                    :type => 'extends',
                    :value => klass.xpath('./extends').text
                },
                {
                    :type => 'final',
                    :value => klass.attribute('final').value
                },
                {
                    :type => 'abstract',
                    :value => klass.attribute('abstract').value
                },
                {
                    :type => 'abstract',
                    :value => klass.attribute('abstract').value
                }
            ]
        }

        new_functions(klass, a)

        new_properties(klass, a)

        a
      end
    end

    def new_functions(klass, hash)
      klass.xpath('./method').map do |method|
        hash[:members] << {
            :type => 'function',
            :value => {
                :doc => docblock_for(method),
                :params => params_for(method),
                :visibility => method.attribute('visibility').value,
                :abstract => method.attribute('abstract').value,
                :static => method.attribute('static').value,
                :final => method.attribute('final').value,
                :line => method.attribute('line').value,
                :inherited_from => method.xpath('./inherited_from').text,
                :name => name_for(method)
            }
        }
      end
    end

    def functions(klass)
      klass.xpath('./method').map do |method|
        {
            :doc => docblock_for(method),
            :params => params_for(method),
            :visibility => method.attribute('visibility').value,
            :abstract => method.attribute('abstract').value,
            :static => method.attribute('static').value,
            :final => method.attribute('final').value,
            :line => method.attribute('line').value,
            :inherited_from => method.xpath('./inherited_from').text,
            :name => name_for(method)

        }
      end
    end

    def files
      @xml_doc.xpath('//file').map do |file|

        a = {
            :hash => file.attribute('hash').value,
            :name => file.attribute('path').value,
            :doc => docblock_for(file),
            # :classes => classes(file),
            # :traits => traits(file),
            :data => []
        }

        if has_classes(file)
          a[:data] << new_classes(file)
        end

        if has_traits(file)
          a[:data] << new_traits(file)
        end

        a
      end
    end

    def export
      hash = {}
      hash[:files] = files
      hash
    end

    private

    def has_classes(file)
      file.xpath('./class').count > 0
    end

    def has_traits(file)
      file.xpath('./trait').count > 0
    end

    def docblock_for(node)
      {
          :description => node.xpath('./docblock/description').text,
          :long_description => node.xpath('./docblock/long-description').text,
          :tags => tags_for(node)
      }
    end

    def tags_for(node)
      node.xpath('./tag').map do |tag|
        {
            :name => tag.attribute('name').value,
            :description => tag.attribute('description').value,
            :type => tag.attribute('type').value,
            :variable => tag.attribute('variable').value
        }
      end
    end

    def name_for(node)
      node.xpath('./name').text
    end

    def params_for(node)
      params = []
      node.xpath('./argument').each do |x|
        params << {
            :name => name_for(x),
            :type => x.xpath('./type').text
        }
      end

      params
    end

    def traits(file)
      file.xpath('./trait').map do |t|
        {
            :line => t.attribute('line').value,
            :name => name_for(t),
            :doc => docblock_for(t),
            :functions => functions(t)

        }
      end
    end

    def new_traits(node)
      node.xpath('./trait').map do |klass|
        a = {
            :structure => 'trait',
            :name => name_for(klass),
            :doc => docblock_for(klass),
            :members => []
        }

        new_functions(klass, a)

        a
      end
    end
    #static="false" visibility="public" namespace="Human" line="21"
    def properties_for(node)
      node.xpath('./property').map do |prop|
        {
            :visibility => prop.attribute('visibility').value,
            :static => prop.attribute('static').value,
            :line => prop.attribute('line').value,
            :name => name_for(prop),
            :doc => docblock_for(prop)
        }
      end
    end

    def new_properties(node, hash)
      node.xpath('./property').map do |prop|
        hash[:members] << {
            :type => 'property',
            :value => {
                :visibility => prop.attribute('visibility').value,
                :static => prop.attribute('static').value,
                :line => prop.attribute('line').value,
                :name => name_for(prop),
                :doc => docblock_for(prop)
            }
        }
      end
    end
  end
end

OneDoc.adapters.register OneDoc::PhpDocument do |target|
  (target.map &:downcase).include?('php')
end