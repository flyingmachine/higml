require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Higml::Config" do
  before :all do
    Higml.config.config_directory = FIXTURE_DIRECTORY
  end
  before :each do
    Higml.config.higml_directory = nil
    Higml.config.global_pairs    = nil
  end
  
  after :all do
    Higml.config.higml_directory = FIXTURE_DIRECTORY
  end
  
  it "should set the config from a yaml filename" do
    Higml.config.set(Higml.config.config_path)
    Higml.config.higml_directory.should == "dir"
    Higml.config.global_pairs.should == {:keywords => :chassis}
  end
  
  it "should set the config from a file" do
    Higml.config.set(File.open(Higml.config.config_path))
    Higml.config.higml_directory.should == "dir"
    Higml.config.global_pairs.should == {:keywords => :chassis}
  end
  
  it "should set the config from a hash" do
    Higml.config.set({
      "higml_directory" => "a",
      "global_pairs"    => {:k   => :v}
    })
    Higml.config.higml_directory.should == "a"
    Higml.config.global_pairs.should == {:k => :v}
  end
end