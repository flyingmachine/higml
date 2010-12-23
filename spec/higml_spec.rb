require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HIGML integration" do
  before :each do
    @input = {
      :action => "show",
      :filter => { :tags => "cat, shakespeare"}
    }
    @mapper_context = Context.new
  end
  
  it "should return the final values using input, higml filename, priority values" do
    priority_map = {:keywords => "tongue paper"}
    values = Higml.values_for(@input, 'search.higml', priority_map, @mapper_context)
    
    values.should == {
      :channel      => "Search",
      :pageName     => "Search Results",
      :keywords     => priority_map[:keywords], # takes priority over @mapper_context.keywords
      :filter_terms => @mapper_context.filter_terms
    }
  end

  it "should allow you to use an existing tree instead of an sc filename" do
    tree = Higml::Parser.new(File.read(File.join(Higml.config.higml_directory, 'search.higml'))).to_tree
    values = Higml.values_for(@input, tree, {}, @mapper_context)

    values.should == {
      :channel      => "Search",
      :pageName     => "Search Results",
      :keywords     => @mapper_context.keywords,
      :filter_terms => @mapper_context.filter_terms
    }
  end
end
