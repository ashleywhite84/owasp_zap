Puppet::Functions.create_function(:'owasp_zap::reports') do
  dispatch :attack do
    param :base
  end
end

module OwaspZap
    class reports
      def initialize(params = {})
          # TODO
          #handle it
          @base = params[:base]
      end

  def xml_report
    RestClient::get "#{base}/OTHER/core/other/xmlreport/"
  end

  def html_report
    RestClient::get "#{base}/OTHER/core/other/htmlreport/"
  end

  def json_report
    RestClient::get "#{base}/OTHER/core/other/jsonreport/"
  end
end
