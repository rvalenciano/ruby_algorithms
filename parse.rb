# Public: Parse a config file in the same folder of this script and returns a hash.
#
# file  - The file to be parsed.
#
#
# Examples
#
#   parse_file('config.txt')
#   Where config.txt is a file at the same folder level of this file.
#   # => { host: 'test.com', server_id: 55531, .... , send_notifications: false }
#
# Returns the configuration of the file in a hash.
def parse_file(file_to_read)
  file = File.open(file_to_read, 'rb')
  contents = file.read
  parser = Parser.new(contents)
  parser.parse
end

# a node of a tree
class Node
  include Enumerable

  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
  end

  def each(&block)
    left.each(&block) if left
    yield(self)
    right.each(&block) if right
  end

  def <=>(other_node)
    data <=> other_node.data
  end
end

# Public: Various methods useful for creating and handling grammar trees.
# The grammar tree is a simple binary tree where the root is the operation, left child the key,
# right child the value
# Examples
#
#   GrammarTree.new(["test_mode", "=", "on")
#   # => GrammarTree [{ self.root: '=' , self.right: 'test_mode', self.left: 'on'"}]
class GrammarTree
  # A grammar is always composed of a recipient, an operation and a assignation value in an array
  attr_accessor :root, :valid
  def initialize(grammar_array)
    self.root = nil
    self.valid = false
    if grammar_array.size == 3
      begin
        self.valid = true
        self.root = Node.new(grammar_array[1])
        root.left = Node.new(grammar_array[0])
        root.right = Node.new(grammar_array[2])
      rescue
        'Error creating the grammar tree'
      end
    end
  end
end

# Public: Various methods useful for creating and handling grammar.
# All methods are instance methods and should be called on the Grammar instance.
# 
# Examples
#
#   Grammar.new("test_mode = on")
#   # => nil
class Grammar
  # Public: Gets/Sets the Grammar tree.
  attr_accessor :tree
  # Public: Initialize a Grammar.
  #  
  # grammar - A String grammar structure. 
  def initialize(grammar)
    tokens = grammar.split(/[ \t]+/)
    has_comments = tokens.index('#')
    if has_comments
      # remove all elements after comments position
      tokens = tokens.each_with_index.each_with_object([]) do |(value, index), result|
        result << value if index < has_comments
        result
      end
    end
    # we should have a well formed grammar
    self.tree = GrammarTree.new(tokens)
  end
end

class Parser
  attr_accessor :content, :mapped_hash, :keys, :values

  SYMBOL_TABLE = {
    INTEGER: /(-?0|-?[1-9]\d*)/,
    FLOAT: /(-?
           (?:0|[1-9]\d*)
           (?:
           \.\d+(?i:e[+-]?\d+) |
           \.\d+ |
          (?i:e[+-]?\d+)
          )
          )/x,
    TRUE: /(true|on|yes)/,
    FALSE:  /(false|off|no)/,
    NULL: /null/,
    COMMENT: /^\s*(#|$)/,
    NEW_LINE: /\r?\n/,
    SPACE_TAB: /[ \t]+/,
    EQUAL: /=/,
    STRING:  /\w+/
  }.freeze

  def type_table(value)
    {
      INTEGER: value.to_i,
      FLOAT: value.to_f,
      TRUE: true,
      FALSE: false,
      NULL: nil,
      STRING: value
      # String, no need for conversion
    }
  rescue
    nil
  end

  def initialize(content)
    self.content = content
    self.mapped_hash = {}
    self.keys = []
    self.values = []
  end

  def evaluate(type, value)
    type_table(value)[type]
  end

  def identify_type(node)
    type = 'NULL'
    SYMBOL_TABLE.each do |key, value|
      next unless node.data.match(value)
      type = key
      break
    end
    type
  end

  def parse
    # We iterate through each line of content, creating a grammar
    # A grammar will be translated into a key - value hash unless is a COMMENT
    begin
      return {} if content.empty? || content.nil?
      content.split(SYMBOL_TABLE[:NEW_LINE]).each do |grammar|
        parsed_grammar = Grammar.new(grammar)
        next unless parsed_grammar.tree.valid
        type = identify_type(parsed_grammar.tree.root.right)
        mapped_hash[parsed_grammar.tree.root.left.data] = evaluate(type, parsed_grammar.tree.root.right.data)
      end
      mapped_hash
    rescue
      'Error parsing the file'
    end
  end
end


# Testing results
result = parse_file('config.txt')
output = 'Printing result'
output += '{ '
result.each_with_index do |(key, value), index|
  output += "#{key} : #{value}"
  output += ', ' unless (index + 1) == result.length
end
output += ' }'
puts output
