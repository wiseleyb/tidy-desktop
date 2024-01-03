#!/usr/bin/env ruby
# frozen_string_literal: true

# chmod a+x tidy-desktop.rb
require 'yaml'
require 'fileutils'
require_relative 'Config'

# Moves files from desktop to and "old" folder. Meant to be used in cron
class TidyDesktop
  def self.run!
    config = Config.new(config_file: ARGV[0] || 'config.yml')

    # create old and old yyyy-mm-dd folder if they don't exist
    FileUtils.mkdir_p(config.old_dir)

    # debug
    if config.debug
      FileUtils.touch File.join(config.desktop_dir, "aaa-#{config.time}.txt")
    end

    files = Dir[File.join(config.desktop_dir, config.ls_pattern)]

    # create old yyyy-mm-dd sub folder if it doesn't exist
    FileUtils.mkdir_p(File.join(config.old_dir, config.old_sub_folder)) if files

    files.each do |file|
      fname = File.basename(file)
      fdest = File.join(config.old_dir, config.old_sub_folder, fname)

      # check time
      st = File.stat(file)
      next unless st.mtime < (config.time - (config.file_age_min * 60))

      if File.exist?(fdest) # add time to filename
        fname_no_ext = File.basename(fname, File.extname(fname))
        fdest =
          File.join(config.old_dir,
                    config.old_sub_folder,
                    "#{fname_no_ext}-#{config.time_str}#{File.extname(fname)}")
      end
      if config.debug
        FileUtils.cp(file, fdest)
      else
        FileUtils.mv(file, fdest)
      end
      puts fdest
    end

    puts "#{files.size} moved at #{Time.now}"
  end
end
TidyDesktop.run!
