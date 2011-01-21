module Higml
  class Applier
    def initialize(input, tree, mapper_context = nil, priority_map = {})
      @input = input
      @tree = tree
      @mapper_context = mapper_context
      @priority_map = priority_map
    end
    
    def result
      @result = {}
      apply_tree
      Higml.config.global_pairs.merge@result.merge(@priority_map)
    end
    
    def apply_tree
      apply_node(@tree)
    end
    
    def apply_node(node)
      if node.selector.nil? || selector_matches?(node.selector)
        apply_values(node.values)
        node.children.each do |child_node|
          apply_node(child_node)
        end
      end
    end
    
    def apply_values(node_values)
      node_values.each do |value|
        next if priority_keys.include? value.key
        if value.static?
          @result[value.key] = value.raw_value
        elsif @mapper_context.nil?
          raise ArgumentError, "you're trying to evaluate code without providing a context"
        else
          @result[value.key] = @mapper_context.instance_eval(value.raw_value)
        end
      end
    end
    
    # REFACTOR to selector class
    def selector_matches?(selector)
      selector.any? do |group|
        group.keys.all? do |key|
          input_has_key?(key) && (@input[key] == group[key] || group[key].nil?)
        end
      end
    end
    
    def input_has_key?(key)
      @input.has_key?(key) && (@input[key] == true || !@input[key].empty?)
    end
    
    def priority_keys
      @priority_keys ||= @priority_map.keys
    end
  end
end
