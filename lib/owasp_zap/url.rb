module OwaspZap
    class url
      def initialize(params = {})
          #TODO
          #handle it
          @base = params[:base]
          @target = params[:target]
      end

      def start
          url = Addressable::URI.parse("#{@base}/JSON/core/action/accessUrl/")
          url.query_values = {:zapapiformat=>"JSON",:url=>@target,:followRedirects=>@redirects}
          RestClient::get url.normalize.to_str
      end

  end
end
