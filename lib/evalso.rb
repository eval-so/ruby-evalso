require "evalso/version"
require "httparty"
require "json"

# TODO: Handle auth, once eval.so supports it.

module Evalso
  API_VERSION = 1

  def self.run(language, code)
    Request.new(language, code).response
  end

  class Request
    include HTTParty
    base_uri 'http://eval.so/api/'

    attr_accessor :response

    def initialize(language, code)
      hash = {
        :api_version => Evalso::API_VERSION,
        :api_key     => "", # Doesn't actually use API keys yet.
        :language    => language.to_s,
        :code        => code,
      }

      opts = {
        :body    => hash.to_json,
        :headers => {
          "Content-Type" => "text/json"
        }
      }

      ret = JSON.parse(self.class.post('/evaluate', opts).body)
      @response = Response.new(code, ret)
    end
def hash;@hash;end
  end

  class Response
    attr_accessor :stdout, :stderr, :wall_time, :remaining_evaluations, :code

    def initialize(code, hash)
      @code   = code
      @stdout = hash["stdout"]
      @stderr = hash["stderr"]
      @wall_time = hash["wallTime"]
      @exit_code = hash["exitCode"]
    end

    def inspect
      "#<#{self.class.name} code=#{code.inspect} stdout=#{stdout.inspect} stderr=#{stderr.inspect} wall_time=#{wall_time.inspect}>"
    end
  end
end

