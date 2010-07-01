require 'spec_helper'

describe RestfulResource::Sweatshop do

  # class Parent
  #   property :id, Serial
  #   property :type, Discriminator
  #   property :first_name, String
  #   property :last_name, String
  # end
  # 
  # class Child < Parent
  #   property :age, Integer
  # end

  before(:each) do
    RestfulResource::Sweatshop.model_map.clear
    RestfulResource::Sweatshop.record_map.clear
  end

  describe ".model_map" do
    it "should return a Hash if the model is not mapped" do
      RestfulResource::Sweatshop.model_map[Class.new].should be_is_a(Hash)
    end

    it "should return a map for names to an array of procs if the model is not mapped" do
      RestfulResource::Sweatshop.model_map[Class.new][:unnamed].should be_is_a(Array)
    end
  end

  describe ".add" do
    it "should app a generator proc to the model map" do
      proc = lambda {}
      lambda {
        RestfulResource::Sweatshop.add(RestfulResource, :parent, &proc)
      }.should change {
        RestfulResource::Sweatshop.model_map[RestfulResource][:parent].first
      }.from(nil).to(proc)
    end

    it "should push repeat procs onto the mapped array" do
      proc1, proc2 = lambda {}, lambda {}

      RestfulResource::Sweatshop.add(RestfulResource, :parent, &proc1)
      RestfulResource::Sweatshop.add(RestfulResource, :parent, &proc2)

      RestfulResource::Sweatshop.model_map[RestfulResource][:parent].first.should == proc1
      RestfulResource::Sweatshop.model_map[RestfulResource][:parent].last.should == proc2
    end
  end

  describe ".expand_callable_values" do
    it 'evalues values that respond to call' do
      RestfulResource::Sweatshop.
        expand_callable_values({ :value => Proc.new { "a" + "b" } }).
        should == { :value => "ab" }
    end
  end

  describe ".attributes" do
    it "should return an attributes hash" do
      RestfulResource::Sweatshop.add(RestfulResource, :parent) {{
        :first_name => /\w+/.gen.capitalize,
        :last_name => /\w+/.gen.capitalize
      }}

      RestfulResource::Sweatshop.attributes(RestfulResource, :parent).should be_is_a(Hash)
    end

    it "should call the attribute proc on each call to attributes" do
      calls = 0
      proc = lambda {{:calls => (calls += 1)}}

      RestfulResource::Sweatshop.add(RestfulResource, :parent, &proc)
      RestfulResource::Sweatshop.attributes(RestfulResource, :parent).should == {:calls => 1}
      RestfulResource::Sweatshop.attributes(RestfulResource, :parent).should == {:calls => 2}
    end

    it "expands callable values" do
      RestfulResource::Sweatshop.add(RestfulResource, :parent) do
        { :value => Proc.new { "a" + "b" } }
      end
      RestfulResource::Sweatshop.attributes(RestfulResource, :parent).should == {
        :value => "ab"
      }
    end
  end

  describe ".pick" do
    it "should return a pre existing instance of a model from the record map" do
      RestfulResource::Sweatshop.add(RestfulResource, :parent) {{
        :first_name => 'George',
        :last_name => 'Clinton'
      }}

      RestfulResource::Sweatshop.create(RestfulResource, :parent)

      RestfulResource::Sweatshop.pick(RestfulResource, :parent).should be_is_a(Hash)
    end
  end
end
