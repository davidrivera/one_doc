require 'digest'
module OneDoc
  class Document

    def initialize(target)
      @target = target
    end

    def namespace
    end

    def class
    end

    def module
    end

    def files
      []
    end

    def doc_for_file(file)
      nil
    end

    def classes_in_file(file)
      []
    end

    def modules_in_file(file)
      []
    end

    def mixins_in_file(file)
      []
    end

    def interfaces_in_file(file)
      []
    end

    # def export
    #   @hash = {}
    #
    #   collect_files(files)
    #
    #   @hash[:files].map! do |file|
    #     file[:classes]
    #   end
    #
    #   @hash
    # end

    protected
    def file_hash_for(file)
      md5 = Digest::MD5.new

      md5.update File.read(@target+'/'+file)

      md5.hexdigest
    end

    private

    def collect_files(files)
      files.each do |file|
        @hash[:files] << {
            :hash => file_hash_for(file),
            :name => file,
            :doc => doc_for_file(file),
            :classes => classes_in_file(file),
            :mixins => mixins_in_file(file),
            :modules => modules_in_file(file),
            :interfaces => interfaces_in_file(file)
        }
      end
    end

  end
end
