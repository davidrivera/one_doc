require 'nokogiri'
require 'rugged'
require 'linguist'

require 'one_doc/parser'

module OneDoc

  def self.adapters(new_registry)
    @adapters = new_registry
  end

  def self.adapters
    @adapters ||= OneDoc::AdapterRegistry.new
  end

end

require 'one_doc/adapters/registry'
require 'one_doc/adapters/document'
require 'one_doc/adapters/php_document'
require 'one_doc/adapters/js_document'