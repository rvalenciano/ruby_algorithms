require 'test/unit'
require './search'

class SearchTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @s = Search.new([456,678,789,790,795,834,923,1023])
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    end

  def test_sequential_search
    assert_equal(7, @s.sequential_search(1023))
  end

  def test_binary_search_1
    assert_equal(7, @s.binary_search(1023))
  end

  def test_binary_search_2
    assert_equal(1, @s.binary_search(678))
  end

  def test_binary_search_3
    assert_equal(-1, @s.binary_search(1000000))
  end

  def test_find_first_occurrence_binary_search_1
    a = [2, 4, 10, 10, 10, 18, 20]
    @s = Search.new(a)
    assert_equal(2, @s.find_first_occurrence_binary_search(10))
  end

  def test_find_last_occurrence_binary_search_1
    a = [2, 4, 10, 10, 10, 18, 20]
    @s = Search.new(a)
    assert_equal(4, @s.find_last_occurrence_binary_search(10))
  end

  def test_find_first_occurrence_binary_search_2
    a = [2, 4, 5, 10, 10, 18, 20]
    @s = Search.new(a)
    assert_equal(3, @s.find_first_occurrence_binary_search(10))
  end


end