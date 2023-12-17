module Parser
  class << self
    def parse(input)
      # pad the parens with spaces on either side so that we can split by space
      tokens = input.gsub(/([()])/, ' \1 ').split(' ').reject(&:empty?)
      output, = parse_tokens(tokens, 0)
      output
    end

    # Given a list of tokens and the index at which have a open parens,
    # parse the tokens up to the matching closing parens and return the index of the next token
    # to process.
    def parse_tokens(tokens, idx)
      raise ArgumentError('The value of tokens[idx] must be `(`.') unless tokens[idx] == '('

      # Since we know that we're currently processing a new list, we can initialize an accumulator
      # to an empty list and advance the pointer
      acc = []
      idx += 1

      while idx < tokens.length
        token = tokens[idx]
        case token
        when ')'
          # Recursive base case: If we reach a closing parens, we're done parsing this list.
          # We return the accumulator and the index of the next token to process
          return acc, idx + 1
        when '('
          # Recursively process a list opening. The recursive call to parse_tokens should return
          # a possibly nested list with all the processed tokens up until the matching closing parens
          # to this open parens

          # We add this to the accumulator and advance the pointer to the token after the matching closing parents
          # for this open parens
          sublist, next_idx = parse_tokens(tokens, idx)
          acc << sublist
          idx = next_idx
        else
          # If we reach a non-parens token we simply add it to the accumulator and advance the pointer
          acc << token
          idx += 1
        end
      end
    end
  end
end
