#!/usr/bin/env ruby
# chmod +x install.rb
require 'fileutils'
include FileUtils

require './tidy_desktop_vars'
include TidyDesktopVars

shell("rm -rf /Users/benwiseley/tmp/tidy-desktop-*.*")

puts "Plist name: #{PLIST_NAME}"
puts "Plist directory: #{PLIST_DIR}"
puts "Plist filename: #{PLIST_FNAME}"
puts ''

puts 'Installing...'

puts ''
puts 'Setting permissions'
shell('chmod a+x tidy-desktop.rb')

puts ''
puts 'Stopping job'
shell("launchctl stop #{PLIST_NAME}")

puts ''
puts 'Unloading job'
shell("launchctl unload #{PLIST_FNAME}")
puts 'Loading job'
shell("launchctl load #{PLIST_FNAME}")

puts ''
puts 'Starting job'
shell("launchctl start #{PLIST_NAME}")

puts ''
puts 'Checking...'
lctl_ls = shell("launchctl list | grep #{PLIST_NAME}").split("\n")

puts ''
puts "Installed: #{lctl_ls.size > 0}"

puts ''
shell("cat /Users/benwiseley/tmp/tidy-desktop-errors.log")
shell("cat /Users/benwiseley/tmp/tidy-desktop-output.log")
#`tail -f /Users/benwiseley/tmp/tidy-desktop-errors.log /Users/benwiseley/tmp/tidy-desktop-output.log`
