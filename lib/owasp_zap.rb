require "json"
require "rest_client"
require "addressable/uri"
require "cgi"
require "logger"

require_relative "owasp_zap/version"
require_relative "owasp_zap/error"
require_relative "owasp_zap/string_extension"
require_relative "owasp_zap/spider"
require_relative "owasp_zap/attack"
require_relative "owasp_zap/alert"
require_relative "owasp_zap/auth"
require_relative "owasp_zap/scanner"
require_relative "owasp_zap/policy"
require_relative "owasp_zap/url"
require_relative "owasp_zap/context"
require_relative "owasp_zap/newsession"
require_relative "owasp_zap/savesession"

module OwaspZap
    class ZapException < Exception;end

    class Zap
       attr_accessor :target,:base,:zap_bin,:sessionname,:overwrite
       attr_reader :api_key
       def initialize(params = {})
            #TODO
            # handle params
            @base = params[:base] || "http://127.0.0.1:8080"
            @target = params[:target,:regex]
            @api_key = params[:api_key]
            @zap_bin = params [:zap] || "C:\\it\\daemon.bat"
            @name    = params [:sessionname]   #creation of new sessions with names and also allows these to be saved with this name
            @overwrite = params [:overwrite]   #allows to set overwirte to true or false
            @redirects  = params [:followRedirects]   # allows the accessurl to for redirections if there is a redirection in place on the site.
            @recurse  =params [:recurse]   # adds recurse to attack to allow it recurse directories
            @context  =params [:context]   #apply on context to a url
            @output = params[:output] || $stdout #default we log everything to the stdout
        end
cmd_line += if params[:api_key] == true
                " -config api.key=#{@api_key}"
        def status_for(component)
            case component
            when :ascan
                Zap::Attack.new(:base=>@base,:target=>@target).status
            when :spider
                Zap::Spider.new(:base=>@base,:target=>@target).status
            when :scan
                Zap::Scan.new(:base=>@base,:target=>@target).status
            else
                {:status=>"unknown component"}.to_json
            end

        end
        def ok?(json_data)
            json_data.is_a?(Hash) and json_data[0] == "OK"
        end

        def running?
            begin
                response = RestClient::get "#{@base}"
            rescue Errno::ECONNREFUSED
                return false
            end
            response.code == 200
        end

        def policy
            Zap::Policy.new(:base=>@base)
        end

        def alerts
            Zap::Alert.new(:base=>@base,:target=>@target)
        end

        def scanner
            Zap::Scanner.new(:base=>@base)
        end

        #attack
        def ascan
            Zap::Attack.new(:base=>@base,:target=>@target,:recurse=>@recurse)
        end

        def spider
            Zap::Spider.new(:base=>@base,:target=>@target)
        end

        def auth
            Zap::Auth.new(:base=>@base)
        end

        #setup of sessions and scan urls with context
        def url
            Zap::Url.new(:base=>@base,:target=>@target,:followRedirects=>@followRedirects)
        end

        def context
            Zap::Context.new(:base=>@base,:regex=>@target,:context=>@context)
        end

        def newSession
          Zap::NewSession.new(:base=>@base,:session=>@name,:overwrite=>@overwrite)
        end

        def saveSession
          Zap::SaveSession.new(:base=>@base,:session=>@name,:overwrite=>@overwrite)
        end

        # TODO
        # DOCUMENT the step necessary: install ZAP under $home/ZAP or should be passed to new as :zap parameter
        def start(params = {})
            # default we are disabling api key
            params = {api_key:true}.merge(params)
            cmd_line = "#{@zap_bin}"
            case
            when params.key?(:daemon)
              cmd_line += " -daemon"
            when params.key?(:api_key)
              cmd_line += if params[:api_key] == true
                " -config api.key=#{@api_key}"
              else
                puts "Api Key missing or incorrect"
              end
            end
            if params.key?(:host)
                cmd_line += " -host #{params[:host]}"
            end
            if params.key?(:port)
                cmd_line += " -port #{params[:port]}"
            end
            fork do
               # if you passed :output=>"file.txt" to the constructor, then it will send the forked process output
               # to this file (that means, ZAP stdout)
               unless @output == $stdout
                STDOUT.reopen(File.open(@output, 'w+'))
                STDOUT.sync = true
               end
               print "Running the following command: #{cmd_line} \n"

               exec cmd_line

            end
        end

        #shutdown zap
        def shutdown
            RestClient::get "#{@base}/JSON/core/action/shutdown/"
        end

        #xml report
        #maybe it should be refactored to alert.
        def xml_report
            RestClient::get "#{@base}/OTHER/core/other/xmlreport/"
        end

        def html_report
            RestClient::get "#{@base}/OTHER/core/other/htmlreport/"
        end

        def json_report
            RestClient::get "#{@base}/OTHER/core/other/jsonreport/"
        end
   end
end
