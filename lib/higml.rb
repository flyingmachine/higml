require 'singleton'
require 'yaml'
require 'higml/applier'
require 'higml/config'
require 'higml/node'
require 'higml/parser'
require 'higml/value'

module Higml
  class << self
    def values_for(input, selector_config, priority_map, mapper_context)
      tree = tree_for_selector_config(selector_config)      
      Higml::Applier.new(input, tree, priority_map, mapper_context).result
    end
    
    def tree_for_selector_config(selector_config)
      case selector_config
      when String
        possible_file_path = File.join(Higml.config.higml_directory, selector_config)
        selector_config = File.read(possible_file_path) if File.exists?(possible_file_path)
        Higml::Parser.new(selector_config).to_tree
      when Higml::Node
        selector_config
      end
    end
  end
end