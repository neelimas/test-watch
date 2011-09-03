require "net/http"
require "rexml/document"
require "json"
require "git_history"

class RevisionInfo

  attr_reader :revision_number, :status

  def initialize(rev, pass)
    @revision_number = rev
    @status = pass
  end

  def to_json(*o1)
    status = @status ? "pass" : "fail"
    '{"revision": "' << @revision_number.to_s << '", "status": "' << status << '"}'
  end

  def pass?
    @status
  end
end

class CodeWatch

  attr_reader :revisions

  def initialize(url)
    @build_url = url << "api/xml"
    @xml_data = Net::HTTP.get_response(URI.parse(@build_url)).body
    @doc = REXML::Document.new(@xml_data)
    @revisions = []
    build_revision_information
  end

  def report
    JSON.pretty_generate({ :build_info => {:build_number => build_number, :status => aggregate_status }, :revisions => @revisions })
  end

  def to_file
    puts report
    File.open('results.json', 'w') { |f| f.write(report) }
  end

  def aggregate_status
    status = true
    @revisions.each do |revision|
      status = status && revision.pass?
    end
    status ? "pass" : "fail"
  end

  def build_number
      @doc.elements['freeStyleBuild/number'].text
  end

  def build_revision_information
    @doc.elements.each('freeStyleBuild/changeSet/item') do |item|
      revision = item.elements["revision"].text
      pass = GitHistory.new(revision).pass?
      @revisions << RevisionInfo.new(revision, pass)
    end
  end
  private :build_revision_information

end
