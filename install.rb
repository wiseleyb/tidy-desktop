#!/usr/bin/env ruby
# chmod +x install.rb
require 'fileutils'
include FileUtils


def shell(cmd)
  puts cmd
  res = `#{cmd}`.chomp
  puts res
  res
end

def shell_sudo(cmd)
  shell("sudo -E #{cmd}")
end

run_every_min = 1
ruby = `which ruby`
fname = File.expand_path('tidy-desktop.rb')
plist_name = 'com.wiseleyb.tidy.desktop'
plist_dir = '/Library/LaunchDaemons'
plist_fname = File.join(plist_dir, "#{plist_name}.plist")

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
    <integer>#{run_every_min * 60}</integer>
    <key>ProgramArguments</key>
    <array>
      <string>#{ruby}</string>
      <string>#{fname}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>benwiseley</string>
    <key>StandardOutPath</key>
    <string>/Users/benwiseley/tidy-desktop-output.txt</string>
    <key>StandardErrorPath</key>
    <string>/Users/benwiseley/tidy-desktop-errors.txt</string>
  </dict>
</plist>
PLIST

puts "Ruby: #{ruby}"
puts "Ruby program: #{fname}"
puts "Plist name: #{plist_name}"
puts "Plist directory: #{plist_dir}"
puts "Plist filename: #{plist_fname}"
puts "Runs every #{run_every_min} minutes"
puts ''
puts "Plist file:"
puts plist
puts ''

puts 'Installing...'

puts ''
puts 'Setting permissions'
shell('chmod a+x tidy-desktop.rb')

puts ''
puts 'Creating/replacing file'
rm_rf plist_fname
File.open(plist_fname, 'w') { |file| file.write(plist) }
shell("cat #{plist_fname}")

puts ''
puts 'Stopping job'
shell_sudo("launchctl stop #{plist_name}")

puts ''
puts 'Unloading job'
shell_sudo("launchctl unload #{plist_fname}")
puts 'Loading job'
shell_sudo("launchctl load #{plist_fname}")

puts ''
puts 'Starting job'
shell_sudo("launchctl start #{plist_name}")

puts ''
puts 'Checking...'
lctl_ls = shell_sudo("launchctl list | grep #{plist_name}").split("\n")

puts ''
puts "Installed: #{lctl_ls.size > 0}"

