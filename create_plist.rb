#!/usr/bin/env ruby
# chmod a+x create_plist.rb
require 'fileutils'
include FileUtils

require './tidy_desktop_vars'
include TidyDesktopVars

# Good guide to Launchd
# https://medium.com/swlh/how-to-use-launchd-to-run-services-in-macos-b972ed1e352
#
plist = <<PLIST
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>Tidy Desktop</string>

    <key>StartInterval</key>
    <integer>#{RUN_EVERY_MIN * 60}</integer>

    <key>ProgramArguments</key>
    <array>
      <string>#{RUBY}</string>
      <string>#{FNAME}</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>UserName</key>
    <string>benwiseley</string>

    <key>StandardOutPath</key>
    <string>/Users/benwiseley/tmp/tidy-desktop-output.log</string>

    <key>StandardErrorPath</key>
    <string>/Users/benwiseley/tmp/tidy-desktop-errors.log</string>

    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string><![CDATA[#{`echo $PATH`.chomp}:/Users/benwiseley/.asdf/shims]]></string>
    </dict>
  </dict>
</plist>
PLIST

puts "Ruby: #{RUBY}"
puts "Ruby program: #{FNAME}"
puts "Plist name: #{PLIST_NAME}"
puts "Plist directory: #{PLIST_DIR}"
puts "Plist filename: #{PLIST_FNAME}"
puts "Runs every #{RUN_EVERY_MIN} minutes"
puts ''
puts "Plist file:"
puts plist
puts ''

puts 'Creating plist file'

puts ''
puts 'Creating/replacing file'
rm_rf PLIST_FNAME
File.open(PLIST_FNAME, 'w') { |file| file.write(plist) }
shell("cat #{PLIST_FNAME}")
