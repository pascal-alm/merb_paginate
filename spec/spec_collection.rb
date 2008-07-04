require 'rubygems'
require 'merb-core'
require 'spec' # Satisfies
require 'will_paginate/array'
require 'will_paginate/collection'


describe  "Collection" do
  it "should result in expected page content" do
    collection = ('a'..'e').to_a
    
    [{ :page => 1,  :per_page => 3,  :expected => %w( a b c ) },
     { :page => 2,  :per_page => 3,  :expected => %w( d e ) },
     { :page => 1,  :per_page => 5,  :expected => %w( a b c d e ) },
     { :page => 3,  :per_page => 5,  :expected => [] },
    ].
    each do |conditions|
      expected = conditions.delete :expected
      expected.should == collection.paginate(conditions)
    end
  end

  it "test_defaults" do
    result = (1..50).to_a.paginate
    1.should == result.current_page
    30.should == result.size
  end

  it "test_deprecated_api" do
    lambda {[].paginate(2)}.should raise_error(ArgumentError)
    lambda {[].paginate(2,10)}.should raise_error(ArgumentError)    
  end

  it "test_total_entries_has_precedence" do
    result = %w(a b c).paginate :total_entries => 5
    5.should == result.total_entries
    result.should == %w(a b c)
  end

  it "test_argument_error_with_params_and_another_argument" do
   lambda {[].paginate({}, 5)}.should raise_error(ArgumentError)
  end

  it "test_paginated_collection" do
    entries = %w(a b c)
    collection = WillPaginate::Collection.create(2, 3, 10) do |pager|
      entries.should == pager.replace(entries)
    end

    entries.should == collection
    %w(total_pages each offset size current_page per_page total_entries).each{ |method|
       collection.should respond_to(method)
    }
    collection.should be_kind_of(Array)
    collection.entries.should be_an_instance_of(Array)
    3.should == collection.offset
    4.should == collection.total_pages
    collection.should_not be_out_of_bounds
  end

  it "test_previous_next_pages" do
   # collection = WillPaginate::Collection.create(1, 1, 3)
   entries = []
   collection = WillPaginate::Collection.create(1, 1, 3) do |pager|
     entries.should == pager.replace(entries)
   end
    collection.previous_page.should be_nil
    2.should == collection.next_page
    
    collection = WillPaginate::Collection.create(2, 1, 3) do |pager|
       entries.should == pager.replace(entries)
     end
    1.should == collection.previous_page
    3.should == collection.next_page
    
    collection = WillPaginate::Collection.create(3, 1, 3) do |pager|
       entries.should == pager.replace(entries)
     end
    2.should == collection.previous_page
    nil.should == collection.next_page
    
    
    
  end
=begin
  def test_out_of_bounds
    entries = create(2, 3, 2){}
    assert entries.out_of_bounds?
    
    entries = create(1, 3, 2){}
    assert !entries.out_of_bounds?
  end

  def test_guessing_total_count
    entries = create do |pager|
      # collection is shorter than limit
      pager.replace array
    end
    assert_equal 8, entries.total_entries
    
    entries = create(2, 5, 10) do |pager|
      # collection is shorter than limit, but we have an explicit count
      pager.replace array
    end
    assert_equal 10, entries.total_entries
    
    entries = create do |pager|
      # collection is the same as limit; we can't guess
      pager.replace array(5)
    end
    assert_equal nil, entries.total_entries
    
    entries = create do |pager|
      # collection is empty; we can't guess
      pager.replace array(0)
    end
    assert_equal nil, entries.total_entries
    
    entries = create(1) do |pager|
      # collection is empty and we're on page 1,
      # so the whole thing must be empty, too
      pager.replace array(0)
    end
    assert_equal 0, entries.total_entries
  end

  def test_invalid_page
    bad_inputs = [0, -1, nil, '', 'Schnitzel']

    bad_inputs.each do |bad|
      assert_raise(WillPaginate::InvalidPage) { create bad }
    end
  end

  def test_invalid_per_page_setting
    assert_raise(ArgumentError) { create(1, -1) }
  end

  def test_page_count_was_removed
    assert_raise(NoMethodError) { create.page_count }
    # It's `total_pages` now.
  end
=end
end
  private
    def create(page = 2, limit = 5, total = nil, &block)
      if block_given?
        WillPaginate::Collection.create(page, limit, total, &block)
      else
        WillPaginate::Collection.new(page, limit, total)
      end
    end

    def array(size = 3)
      Array.new(size)
    end

    
