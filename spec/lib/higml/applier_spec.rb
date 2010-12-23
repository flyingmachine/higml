require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Higml::Applier" do
  it "should use a tree to build a result from input" do
    tree = Higml::Parser.new(File.read(File.join(Higml.config.higml_directory, 'search.higml'))).to_tree
    
    input = {
      :action => "show",
      :filter => { :tags => "cat, shakespeare"}
    }
    
    priority_map = {:keywords => "tongue paper"}
    mapper_context = Context.new
    
    values = Higml::Applier.new(input, tree, priority_map, mapper_context).result
    
    values.should == {
      :channel => "Search",
      :pageName => "Search Results",
      :keywords => priority_map[:keywords],
      :filter_terms => mapper_context.filter_terms
    }
  end
  
  it "should test all groups in a selector" do
    tree = Higml::Parser.new(File.read(File.join(Higml.config.higml_directory, 'selectors_with_groups.higml'))).to_tree
    
    input_group_1 = {
      :action => "show",
      :filter => { :tags => "cat, shakespeare"}
    }
    
    input_group_2 = {
      :action => "new",
      :filter => { :tags => "cat, shakespeare"}
    }
    
    priority_map = {}
    
    mapper_context = Context.new
    Higml::Applier.new(input_group_1, tree, priority_map, mapper_context).result.should == {:filter => "filtered!"}
    Higml::Applier.new(input_group_2, tree, priority_map, mapper_context).result.should == {:filter => "filtered!"}
  end
end