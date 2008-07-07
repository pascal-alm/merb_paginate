require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

#COMBO Controller and view tests, because view merb rspecs flakey

describe Posts, "#index" do

  describe "timings for 100 calls with generated view" do
    it "random pages random num elements" do
     start = Time.now
    (1..100).each{|i|
      @response = dispatch_to(Posts, :index, {:limit=>rand(200), :page=> (1 + i.divmod(6)[1])})
      @response.should respond_successfully
    }
    p "#{Time.now - start} seconds for 100 calls random pages"
    end
    it "first page random num elements" do
     start = Time.now
    (1..100).each{|i|
      @response = dispatch_to(Posts, :index, {:limit=>rand(200)})
      @response.should respond_successfully
    }
    p "#{Time.now - start} seconds for 100 calls first page"
    end
    it "1st page high random num elements (more than max items)" do
     start = Time.now
    (1..100).each{|i|
      @response = dispatch_to(Posts, :index, {:limit=>200 + rand(200)})
      @response.should respond_successfully
    }
    p "#{Time.now - start} seconds for 100 calls high limit"
    end
  
    it "first page full list" do
     start = Time.now
    (1..100).each{|i|
      @response = dispatch_to(Posts, :index)
      @response.should respond_successfully
    }
    p "#{Time.now - start} seconds for 100 calls no limit"
    end
  end

end