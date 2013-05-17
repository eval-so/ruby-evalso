require 'evalso/language'

class Evalso
  module Languages
    class << self
      def languages
        raw = HTTParty.get(Evalso.base_uri + 'languages').body
        parse(JSON.parse(raw))
      end

      def parse(hash)
        hash.keys.each do |k|
          hash[k] = Language.new(k, hash[k])
        end

        hash
      end
    end
  end
end
