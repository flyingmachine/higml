module Higml
  class Node
    attr_accessor :selector, :children, :values
    def initialize
      self.values = []
      self.children = []
    end
  end
end
