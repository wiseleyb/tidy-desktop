#!/usr/bin/env ruby
# chmod a+x tidy-desktop.rb
require 'fileutils'
include FileUtils

desktop = 'Desktop'
ls_pattern = '*.*'
old_dir_name = 'old2'
t = Time.now.strftime('%Y%m%d_%I%M%S')

desktop_dir = File.join(File.expand_path('~'), desktop)
old_dir = File.join(desktop_dir, old_dir_name)
mkdir_p(old_dir)

# debug
touch File.join(desktop_dir, "aaa-#{t}.txt")

files = Dir[File.join(desktop_dir, ls_pattern)]
files.each do |file|
  fname = File.basename(file)
  fdest = File.join(old_dir, fname)

  if File.exist?(fdest) # add time to filename
    fname_no_ext = File.basename(fname, File.extname(fname))
    fdest =
      File.join(old_dir,
                "#{fname_no_ext}-#{t}#{File.extname(fname)}")
  end
  mv(file, fdest)
  puts fdest
end

puts 'done'
