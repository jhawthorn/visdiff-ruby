require 'visdiff/client'

class Visdiff::TestRun
  attr_reader :revision
  attr_accessor :enabled

  alias_method :enabled?, :enabled

  delegate :api_key=, :base_url=, :debug=, to: :client_config
  delegate :identifier=, :description=, to: :revision

  def initialize
    visdiff = Visdiff::Client.new
    @revision = visdiff.revision
    @enabled = false
  end

  def submit!
    return false unless enabled?

    revision.submit!
  end

  def enable
    self.enabled = true
  end

  def revision_from_git!
    git_sha, git_desc = `git rev-list --format=%B --max-count=1 HEAD`.split("\n")
    git_sha.gsub!(/\Acommit /, '')
    self.identifier = git_sha
    self.description = git_desc
  end

  def observe_page(identifier, page)
    return false unless enabled?

    tmppath = "tmp/visdiff/#{SecureRandom.hex}.png"
    page.driver.render(tmppath, full: true)
    revision.add_image identifier, tmppath
  end

  private

  def client_config
    revision.client.config
  end
end

