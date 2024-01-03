# frozen_string_literal: true

require 'yaml'

# Manages config settings to tidy-desktop and config.yml
class Config
  attr_accessor :desktop, :ls_pattern, :file_age_min, :time, :time_str,
                :debug, :old_dir_name, :old_sub_folder, :desktop_dir,
                :old_dir, :run_cron, :ruby_bin,
                :tidy_desktop_file, :tidy_desktop_log_file,
                :config_file

  def initialize(config_file: 'config.yml')
    config = Config.load(config_file)
    # you normally do this with reverse_merge but that'd require Rails
    if config[:debug].nil?
      config[:debug] = config[:debug].to_s.downcase[0] == 't'
    end
    config[:desktop] ||= 'Desktop'
    config[:ls_pattern] ||= '*.*'
    config[:file_age_min] ||= '30'
    config[:old_dir_name] ||= 'old'
    config[:run_cron] ||= '15'
    config[:ruby_bin] ||= `which ruby`.chomp
    config[:tidy_desktop_file] ||= File.expand_path('tidy-desktop.rb')
    config[:tidy_desktop_log_file] ||= File.expand_path('tidy-desktop.log')

    # time to check against
    @time = Time.now

    # debug mode copies files to old2 instead of moving to old
    @debug = config[:debug].to_s.downcase == 'true'

    # desktop folder
    @desktop = config[:desktop]

    # pattern for files to move to old directory
    @ls_pattern = config[:ls_pattern]

    # file must be this minutes old to move
    @file_age_min = config[:file_age_min].to_i

    # how often cron runs
    @run_cron = config[:run_cron].to_i

    # location of ruby binary
    @ruby_bin = config[:ruby_bin]

    # tidy-desktop.rb with full path
    @tidy_desktop_file = config[:tidy_desktop_file]

    # tidy-desktop log with pull path
    @tidy_desktop_log_file = config[:tidy_desktop_log_file]

    # used to add on to filename if filename already exists
    @time_str = @time.strftime('%Y%m%d_%I%M%S')

    # desktop directory folder to move old files to
    # @old_dir_name = @debug ? 'old2' : 'old'
    @old_dir_name = config[:old_dir_name]

    # sub folder in old to put files in
    @old_sub_folder = "tidy-desktop-#{@time.strftime('%Y-%m-%d')}"

    # desktop directory
    @desktop_dir = File.join(File.expand_path('~'), @desktop)

    # old dir directory
    @old_dir = File.join(@desktop_dir, @old_dir_name)
  end

  def crontab_cmd
    [
      "*/#{run_cron} * * * *",
      ruby_bin,
      tidy_desktop_file,
      config_file,
      '>>',
      tidy_desktop_log_file,
      '2>&1'
    ].join(' ')
  end

  # returns hash with symbolized keys
  def self.load(config_file)
    if File.exist?(config_file)
      config = YAML.safe_load(File.read(config_file))
    else
      config = {}
    end
    config.transform_keys!(&:to_sym)
  end

  # stringifys keys and saves to yaml
  # returns filename with full path
  def self.save(hash, config_file = 'config.yml')
    FileUtils.rm_f(config_file)
    File.open(config_file, 'w') do |f|
      # transform_keys is stringify_keys without rails
      # yaml allows symbols but it's totally non standard
      f.write(hash.transform_keys(&:to_s).to_yaml)
    end
    File.expand_path(config_file)
  end

  # simple shell helper
  def shell(cmd) = Config.shell(cmd)

  def self.shell(cmd)
    puts cmd
    res = `#{cmd}`.chomp
    puts res
    res
  end
end
