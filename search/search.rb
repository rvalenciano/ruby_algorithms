class Search
  attr_accessor :array_to_search_in

  def initialize
    @array_to_search_in = Array.new(100) { rand(1..100) }
  end

  def initialize(arr)
    @array_to_search_in = arr
  end


  # @param [integer] x: Search x in array
  # @return [integer] r: Index of found element or -1 if not
  # This is the most basic form of search, and the dumbest, pure brute force
  # O(N) in the worst case
  def sequential_search(x)
    i = -1
    @array_to_search_in.each_with_index do |value, index|
      i = index if value == x
    end
    i
  end


  # @param [integer] x: Search x in array
  # @return [integer] r: Index of found element or -1 if not
  # O(log(N)) however requires a sorted array to work
  def binary_search(x)
    i = auxiliar_binary_search(x, @array_to_search_in)
  end


  def find_first_occurrence_binary_search(x)
    i = auxiliar_binary_search(x, @array_to_search_in, 0, @array_to_search_in.size, true)
  end

  def find_last_occurrence_binary_search(x)
    i =  auxiliar_binary_search(x, @array_to_search_in, 0, @array_to_search_in.size, false, true)
  end

  private
  # @param [integer] x
  # @param [Array] arr
  # @param [integer] beginning
  # @param [integer] ending
  # @param [boolean] first  if we need to retrieve the first occurrence in array
  # @param [boolean] last  if we need to retrieve the last occurrence in array
  # @return [integer] index in array of found element
  def auxiliar_binary_search(x, arr, beginning = 0, ending = arr.size, first = false, last = false)
    puts " ###### "
    puts " beginning #{beginning}"
    puts " ending #{ending}"
    mid = ( beginning + ending ) / 2
    puts " mid #{mid}"
    r = -1
    if arr[mid] == x
      # we found it yay
      if first
        ending = mid - 1
        r = mid
        i = auxiliar_binary_search(x, arr, beginning, ending, true, false)
        return r if i == -1
        return i
      elsif last
        r = mid
        beginning = mid + 1
        i = auxiliar_binary_search(x, arr, beginning, ending, false, true)
        return r if i == -1
        return i
      else
        return mid
      end
    elsif ending == beginning
      return -1
    elsif arr[mid] < x
      auxiliar_binary_search(x, arr, mid + 1, ending)
    else
      auxiliar_binary_search(x, arr, beginning, mid - 1)
    end
  end


end