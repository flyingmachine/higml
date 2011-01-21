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
    values = Higml.values_for(@input, 'search.higml', @mapper_context, priority_map)
    
    values.should == {
      :channel      => "Search",
      :pageName     => "Search Results",
      :keywords     => priority_map[:keywords], # takes priority over @mapper_context.keywords
      :filter_terms => @mapper_context.filter_terms
    }
  end

  it "should allow you to use an existing tree instead of an sc filename" do
    tree = Higml::Parser.new(File.read(File.join(Higml.config.higml_directory, 'search.higml'))).to_tree
    values = Higml.values_for(@input, tree, @mapper_context)

    values.should == {
      :channel      => "Search",
      :pageName     => "Search Results",
      :keywords     => @mapper_context.keywords,
      :filter_terms => @mapper_context.filter_terms
    }
  end
  
  it "should work ok without mapper context or priority map" do
    lambda{Higml.values_for({:action => "new"}, 'search.higml')}.should_not raise_error
  end
  
  it "should raise an error if applying a rule which requires a context, where none is provided" do
    lambda{Higml.values_for({:action => "show", :keywords => "what"}, 'search.higml')}.should raise_error
  end
end
