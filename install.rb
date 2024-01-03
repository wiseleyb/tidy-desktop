#!/usr/bin/env ruby
# frozen_string_literal: true

# chmod a+x install.rb
require 'yaml'
require 'fileutils'
require_relative 'Config'

# Creates config.yml and generates cron command
class Install
  def self.run!
    yhash = {}

    section('Creating config file for tidy-desktop')

    # reset log
    section('Reset tidy-desktop.log') do
      FileUtils.rm_f('tidy-desktop.log')
      FileUtils.touch('tidy-desktop.log')
    end

    yhash[:debug] = false

    yhash[:desktop] = pgets('Desktop folder name?', 'Desktop')
    yhash[:ls_pattern] = pgets('File pattern to check?', '*.*')
    yhash[:file_age_min] =
      pgets("Ignore files until they're this many minutes old", '30')
    yhash[:old_dir_name] = pgets('Desktop folder to move files to?', 'old')
    yhash[:ruby_bin] = pgets('Ruby binary location?', `which ruby`.chomp)
    yhash[:run_cron] = pgets('Cron will run every X minutes', '15')
    yhash[:tidy_desktop_file] =
      pgets('Location of tidy-desktop.rb?',
            File.expand_path('tidy-desktop.rb'))
    yhash[:tidy_desktop_log_file] =
      pgets('Location of tidy-desktop.log?',
            File.expand_path('tidy-desktop.log'))

    # save to yaml
    config_file = Config.save(yhash)

#    yhash[:tidy_config] = File.expand_path('config.yml')

    section('Created config.yml for future editing')

    section('Will now try to do a test run of tidy-desktop.rb') do
      res = pgets('Proceed?', 'Y')
      if res.to_s.downcase[0] == 'y'
        Config.shell("./tidy-desktop.rb #{config_file}")
      else
        puts 'OK. Skipping. Done'
        return
      end
    end

    section('Add to cron tab') do
      puts 'If the script ran as expected you just need to add this to cron.'
      puts 'Use "crontab -e" to add this line.'
      pblank
      pblank
      puts Config.new(config_file: config_file).crontab_cmd
      pblank
    end

    section('debugging', 'If things are working you can check the logs') do
      puts 'Try running:'
      puts 'tail -f tidy-desktop.log'
    end

    section('Done')
  end

  def self.pgets(question, default)
    pline
    puts "#{question} (default: #{default})"
    res = gets.chomp
    res.to_s.strip == '' ? default : res
  end

  def self.pline
    puts '-' * 80
  end

  def self.pblank
    puts ''
  end

  def self.section(title, desc = nil)
    pline
    if desc
      puts title.upcase
      puts desc
    else
      puts title
    end
    yield if block_given?
    pblank
  end
end
Install.run!
