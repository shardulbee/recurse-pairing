require_relative './parser'

def assert_equal(expected, actual, message = '')
  raise "Expected #{expected} but got #{actual}. #{message}" unless expected == actual
end

def test_parse
  assert_equal(['first', ['list', '1', ['+', '2', '3'], '9']], Parser.parse('(first (list 1 (+ 2 3) 9))'))
  assert_equal(['list', '1', '2', '3', '4'], Parser.parse('(list 1 2 3 4)'))
  assert_equal(['list', '1', '2', ['list', '3', '4']], Parser.parse('(list 1 2 (list 3 4))'))
  assert_equal(['list', '1', '2', %w[list 3 4], '5'], Parser.parse('(list 1 2 (list 3 4) 5)'))
  assert_equal(['list', '1', '2', %w[list 3 4], '5', %w[list 6 7]], Parser.parse('(list 1 2 (list 3 4) 5 (list 6 7))'))
  assert_equal(['list', '1', '2', %w[list 3 4], '5', %w[list 6 7], '8'],
               Parser.parse('(list 1 2 (list 3 4) 5 (list 6 7) 8)'))
  assert_equal(['list', ['list', ['list', ['list', ['list', %w[list 1]]]]]],
               Parser.parse('(list (list (list (list (list (list 1))))))'))
  assert_equal(['list', '1', '2', ['+', '3', '4']], Parser.parse('(list 1 2 (+ 3 4))'))
  assert_equal(['list', '1', '2', %w[list nil 3 4]], Parser.parse('(list 1 2 (list nil 3 4))'))
  assert_equal(['or', ['and', '"zero"', 'nil', '"never"'], '"James"', "'task", "'time"],
               Parser.parse('(or (and "zero" nil "never") "James" \'task \'time)'))
  true
rescue StandardError => e
  puts e.message
  false
end

puts "Parse tests: #{test_parse ? 'PASSED' : 'FAILED'}"
