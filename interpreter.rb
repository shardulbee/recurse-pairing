module Interpreter
  class << self
    # interpret([]) -> nil

    def interpret(ast)
      # We're going to assume the first element of AST is always a "function" which willl be applied
      # to the following elemnts
      return nil if ast.empty?

      fn = ast.first
      arguments = ast[1..]

      case fn
      when '+'
        arguments = arguments.map do |argument|
          if argument.is_a?(Array)
            interpret(argument)
          else
            argument.to_i
          end
        end
        arguments.inject(0, :+)
      when 'list'
        arguments.map do |argument|
          if argument.is_a?(Array)
            interpret(argument)
          else
            argument.to_i
          end
        end
      when 'first'
        raise unless arguments.length == 1
        raise unless arguments.first.is_a?(Array)

        # we need to intepret the list to make sure that any sublists have been processed
        interpret(arguments.first).first
      end
    end
  end
end
