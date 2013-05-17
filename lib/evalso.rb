require "evalso/version"
require "httparty"
require "json"
require "base64"

require 'evalso/languages'

# TODO: Handle auth, once eval.so supports it.

# Current API docs: http://eval.so/api/1

class Evalso
  API_VERSION = 1
  DEFAULT_URI = "http://eval.so/api/"

  class HTTPError < Exception; end

  def self.base_uri(uri = nil)
    return @@base_uri unless uri

    @@base_uri = uri
  end

  base_uri DEFAULT_URI

  def self.run(hash)
    Request.new(hash).response
  end

  def self.languages
    Evalso::Languages.languages
  end

  class Request
    include HTTParty

    # Usage:
    #   Evalso::Request.new(lang, code, inputFiles: ["filename.txt"])
    # or
    #   Evalso::Request.new(language: lang, code: code, inputFiles: {"filename.txt" => "file contents"})
    #
    # Defaults:
    #   Evalso::Request.new(language: nil, code: nil, inputFiles: {}, compilationOnly: false)
    #
    # If `language` or `code` are not specified, an ArugmentError is raised.
    def initialize(hash)
      self.class.base_uri Evalso.base_uri

      hash = {
        :api_version => Evalso::API_VERSION,
        :language    => nil,
        :code        => nil,
        :inputFiles  => {},
        :compilationOnly => false,
      }.merge(hash)

      raise ArgumentError, "no language specified." unless hash[:language]
      raise ArgumentError, "no code specified."     unless hash[:code]

      hash[:inputFiles] = handle_input_files(hash[:inputFiles])

      @hash = hash
    end

    def response
      opts = {
        :body    => @hash.to_json,
        :headers => {
          "Content-Type" => "text/json"
        }
      }

      resp = self.class.post('/evaluate', opts)
      ret = JSON.parse(resp.body)

      if !resp.response.is_a?(Net::HTTPSuccess)
        error = ret['error']
        error ||= "#{resp.response.code} #{resp.response.msg.inspect}"
        raise Evalso::HTTPError, ret['error']
      end

      @response = Response.new(@hash[:code], ret)
    end

    def handle_input_files(files)
      # If files is an array of filenames,
      # make it a hash of filenames => file content.
      if files.is_a?(Array)
        ret = {}
        files.each do |file|
          ret[file] = open(file).read
        end

        files = ret
      end

      files.keys.each do |file|
        files[file] = Base64.encode64(files[file])
      end

      files
    end
  end

  class Response
    attr_reader :code, :stdout, :stderr, :return, :wall_time,
                :remaining_evaluations, :output_files, :compilation_result

    def initialize(code, hash)
      @code   = code
      @stdout = hash["stdout"]
      @stderr = hash["stderr"]
      @return = hash["return"]
      @wall_time = hash["wallTime"]
      @exit_code = hash["exitCode"]
      @output_files = handle_output_files(hash["outputFiles"] || {})
      @compilation_result = hash["compilationResult"]
    end

    def handle_output_files(files)
      files.keys.each do |file|
        files[file] = Base64.decode64(files[file])
      end
    end

    def inspect
      "#<#{self.class.name} code=#{code.inspect} stdout=#{stdout.inspect} stderr=#{stderr.inspect} wall_time=#{wall_time.inspect}>"
    end
  end
end

