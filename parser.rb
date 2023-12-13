module Parser
  class << self
    def parse(input)
      tokens = input.gsub(/([()])/, ' \1 ').split(' ').reject(&:empty?)
      output, = parse_tokens(tokens, 0)
      output
    end

    # Given a list of tokens and the index at which it is guaranteed to have a open parens,
    # parse the tokens up to the matching closing parens and return the index of the next token
    # to process.
    def parse_tokens(tokens, idx)
      acc = []
      idx += 1

      while idx < tokens.length
        token = tokens[idx]
        case token
        when ')'
          return acc, idx + 1
        when '('
          sublist, next_idx = parse_tokens(tokens, idx)
          acc << sublist
          idx = next_idx
        else
          acc << token
          idx += 1
        end
      end
    end
  end
end

def assert_equal(expected, actual, message = '')
  raise "Expected #{expected} but got #{actual}. #{message}" unless expected == actual
end

assert_equal(['first', ['list', '1', ['+', '2', '3'], '9']], Parser.parse('(first (list 1 (+ 2 3) 9))'))
assert_equal(%w[list 1 2 3 4], Parser.parse('(list 1 2 3 4)'))
assert_equal(['list', '1', '2', %w[list 3 4]], Parser.parse('(list 1 2 (list 3 4))'))
assert_equal(['list', '1', '2', %w[list 3 4], '5'], Parser.parse('(list 1 2 (list 3 4) 5)'))
assert_equal(['list', '1', '2', %w[list 3 4], '5', %w[list 6 7]], Parser.parse('(list 1 2 (list 3 4) 5 (list 6 7))'))
assert_equal(['list', '1', '2', %w[list 3 4], '5', %w[list 6 7], '8'], Parser.parse('(list 1 2 (list 3 4) 5 (list 6 7) 8)'))
assert_equal(['list', ['list', ['list', ['list', ['list', ['list', '1']]]]]], Parser.parse('(list (list (list (list (list (list 1))))))'))
assert_equal(['list', '1', '2', ['+', '3', '4']], Parser.parse('(list 1 2 (+ 3 4))'))
assert_equal(['list', '1', '2', ['list', 'nil', '3', '4']], Parser.parse('(list 1 2 (list nil 3 4))'))
assert_equal(['or', ['and', '"zero"', 'nil', '"never"'], '"James"', "'task", "'time"], Parser.parse('(or (and "zero" nil "never") "James" \'task \'time)'))