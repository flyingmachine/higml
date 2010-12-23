require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Higml::Parser" do
  it "should build a node tree from a properly formatted file" do
    tree = Higml::Parser.new(File.read(File.join(Higml.config.higml_directory, 'search.higml'))).to_tree
    
    tree.values[0].key.should == :channel
    tree.values[0].pre_value.should == "Search"
    
    tree.children[0].selector.should == [{:action => "new"}]
    tree.children[0].values[0].key.should == :pageName
    tree.children[0].values[0].pre_value.should == "New Search"
    
    tree.children[1].selector.should == [{:action => "show"}]
    tree.children[1].values[0].key.should == :pageName
    tree.children[1].values[0].pre_value.should == "Search Results"
    tree.children[1].values[0].type.should == :static
    
    tree.children[1].values[1].key.should == :keywords
    tree.children[1].values[1].pre_value.should == "keywords"
    tree.children[1].values[1].type.should == :dynamic
  end
  
  it "should import values" do
    tree = Higml::Parser.new(File.read(File.join(Higml.config.higml_directory, 'with_import.higml'))).to_tree
    tree.values[0].key.should == :applicationName
    tree.values[0].pre_value.should == "WOO Application"
    tree.values[1].key.should == :test
    tree.values[1].pre_value.should == "yes"
  end
end