module Higml
  class Parser
    attr_accessor :source
    
    def initialize(source)
      @source = source
      prepend_imports
    end
    
    def prepend_imports
      already_imported = []
      process_imports(@source, already_imported)
    end
    
    def process_imports(current_source, already_imported)
      current_source.each_line do |line|
        line = Line.new(line)
        if line.type == :import
          filename = line.to_import
          next if already_imported.include?(filename)
          already_imported << filename
          new_source = File.read(File.join(Higml.config.higml_directory, filename))
          @source = new_source + "\n" + @source
          process_imports(new_source, already_imported)
        else
          break
        end
      end
    end
    
    def to_tree
      current_node = Node.new
      node_stack = [current_node]
      indentation_level = 0
      
      source.each_line do |line|
        next if line.strip.empty?
        line = Line.new(line)
        
        case line.type 
        when :value
          # TODO move this comment
          # Every drop in indentation corresponds to a new node;
          # It doesn't make sense to drop indentation level and 
          # define further values
          current_node.values << line.to_value
        when :selector
          if line.indentation_level >= indentation_level
            node_stack.push current_node
          else
            node_stack_to_pop = indentation_level - line.indentation_level - 1
            node_stack.slice!(node_stack.size - node_stack_to_pop, node_stack.size)
          end
          current_node = Node.new
          current_node.selector = line.to_selector
          node_stack.last.children << current_node
        else
          next
        end
        indentation_level = line.indentation_level        
      end
      node_stack[0]
    end
    
    
    class Line
      VALUE_INDICATOR = 58
      IMPORT_INDICATOR = 64
      COMMENT_INDICATOR = 47
      
      attr_reader :source, :stripped_source
      
      def initialize(source)
        @source = source
        @stripped_source = source.strip
      end
      
      # Every two spaces is one indentation level
      def indentation_level
        spaces = (@source.size - @stripped_source.size)
        spaces == 0 ? 0 : spaces / 2
      end
      
      def type
        case @stripped_source[0]
        when VALUE_INDICATOR: :value
        when IMPORT_INDICATOR: :import
        when COMMENT_INDICATOR: :comment
        else
          :selector
        end
      end
      
      def to_selector
        @stripped_source.split(",").collect do |group|
          selector = {}
          group = group.strip
          group.split(" ").each do |pair|
            key, value = pair.split(":")
            selector[key.to_sym] = value || nil
          end
          selector
        end
      end
      
      def to_value
        Value.new(self)
      end
      
      def to_import
        /@import (.*)/.match(@stripped_source)[1]
      end
    end
  end
end