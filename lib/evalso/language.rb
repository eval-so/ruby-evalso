class Evalso
  class Language
    attr_reader :id, :name

    def initialize(id, hash)
      @hash = hash
      @id   = id

      @name = hash['display_name']
    end

    def run(hash)
      hash.merge!({ :language => id })
      Evalso.run(hash)
    end

    def inspect
      %[#<#{self.class.name} name=#{name.inspect} id=#{id.inspect}>]
    end
  end
end
