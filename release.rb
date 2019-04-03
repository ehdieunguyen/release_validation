# 1. Get new version + note

# 2. Get current version from other services

# 3. Compare and push notification to slack channel

require 'octokit'
require 'bundler'

ACCESS_TOKEN = "645957442ad3b783d05def48e69706689c3f7846"
GEM_NAME = 'octokit'

TARGET_GEM_VERSION = Gem::Version.new('2.1.1')

module Notifier
  class SlackNotifier
    def call(args)

    end

    def new(slack_id, message)
      @slack_id = slack_id
      @message = message
    end

    def call

    end
  end
end

class CompatibleLibNotify
  SLACK_CHANNEL = 'eh-v13s-alerts'
  LIB_LIST = [
    AUDIT_HERO = 'audit_hero',
    EASY_THROTTLE_LIMIT = 'easy_throttle_limit',
    EH_MYOB = 'eh-myob',
    EH_XERO = 'eh_xero',
    EH_KEYPAY = 'eh-keypay',
    EH_MONITORING = 'eh_monitoring',
    EH_PROTOBUF = 'eh_protobuf',
    FF_ASSISTANT = 'feature_flag_assistant',
    KEY_PAY = 'key_pay'
  ]

  class CompatibleVersionError < StandardError; end

  def self.call(*args)
    new(*args).call
  end

  attr_reader :repo, :gem_name, :target_version, :errors

  def initialize(repo, gem_name, target_version)
    @repo = repo
    @gem_name = gem_name
    @target_version = target_version
    @errors = []
  end

  def success?
    errors.blank?
  end

  def call
    get_current_version(repo)
    get_notes_between_versions(current_version, target_version)

    if success?
      push_slack_notification(owners)
    end
  end

  private

  def get_current_version(repo)
    gem_lock_content = client.content(repo, path: './Gemfile.lock')

    decode_plain_content = Base64.decode64(gem_lock_content[:content])
    structure_content = Bundler::LockfileParser.new decode_plain_content

    spec = structure_content.specs.find{|item| item.name == gem_name}
    @current_version = spec&.version
  rescue Octokit::Unauthorized => e
    errors << e.message
    puts e.message
  rescue Octokit::NotFound => e
    errors << e.message
    puts e.message
  rescue NoMethodError => e
    errors << e.message
    puts e.message
  rescue CompatibleVersionError => e
    errors << e.message
    puts e.message
  end

	def get_notes_between_versions(current_version, target_version)
    if current_version.nil?
      raise CompatibleVersionError.new("Not found the gem with current version #{current_version}")
    end

    if current_version == target_version
      raise CompatibleVersionError.new('The current verstion is target version')
    end

    releases = client.list_releases(repo)
  end

	def push_slack_notification
    puts 'Ahihi'
	end

	def client
		@client = Octokit::Client.new(:access_token => ACCESS_TOKEN)
	end

	def tag_name
		@tag_name = 'v' + target_verion
	end
end


