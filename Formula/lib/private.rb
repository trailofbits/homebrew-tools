require "download_strategy"

class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  require "utils/github"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid URL pattern for GitHub Release."
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def sanitized_download_url
    download_url.gsub(/\/\/.*@/, "//REDACTED@")
  end
  
  def download_url
    "https://#{@github_token}@api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  def fetch(timeout: nil, **options)
    original_url = @url
    @url = download_url
    ohai "Downloading #{sanitized_download_url}"
    super
    @url = original_url
  end

  private


  def set_github_token
    @github_token = get_github_token_from_keychain
    unless @github_token
      raise CurlDownloadStrategyError, "GitHub token not found in macOS Keychain."
    end

    validate_github_repository_access!
  end

  def get_github_token_from_keychain
    keychain_output = `security find-internet-password -w -s 'github.com' 2>/dev/null`.strip
    return nil if keychain_output.empty?

    keychain_output
  end

  def validate_github_repository_access!
    GitHub.repository(@owner, @repo)
  rescue GitHub::HTTPNotFoundError
    message = <<~EOS
      Cannot access the repository: #{@owner}/#{@repo}
      This token may not have permission to access the repository or the URL of the formula may be incorrect.
    EOS
    raise CurlDownloadStrategyError, message
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    GitHub::API.open_rest(release_url)
  end
end
