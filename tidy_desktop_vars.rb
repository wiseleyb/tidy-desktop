module TidyDesktopVars
  # desktop folder
  DESKTOP = 'Desktop'

  # pattern for files to move to old directory
  LS_PATTERN = '*.*'

  # file must be this minutes old to move
  FILE_AGE_MIN = 10

  # Time to check against
  TIME = Time.now

  # Used to add on to filename if filename already exists
  TIME_STR = TIME.strftime('%Y%m%d_%I%M%S')

  # Debug mode copies files to old2 instead of moving to old
  DEBUG = false

  # Desktop directory folder to move old files to
  OLD_DIR_NAME = DEBUG ? 'old2' : 'old'

  # Sub folder in old to put files in
  OLD_DIR_DAY_FOLDER = "tidy-desktop-#{TIME.strftime('%Y-%m-%d')}"

  # Desktop directory
  DESKTOP_DIR = File.join(File.expand_path('~'), DESKTOP)

  # old dir directory
  OLD_DIR = File.join(DESKTOP_DIR, OLD_DIR_NAME)


  # ruby file to run to clean things up
  FNAME = File.expand_path('tidy-desktop.rb')

  # ---------------------------------------------
  # Plist specific (not currently working)

  # plist name
  PLIST_NAME = 'com.wiseleyb.tidy.desktop'
  # how often to run
  RUN_EVERY_MIN = 1
  # where is the ruby bin file located
  RUBY = `which ruby`
  # location to put .plist file in
  PLIST_DIR = '/Library/LaunchAgents'
  # file name and path of plist file
  PLIST_FNAME = File.join(PLIST_DIR, "#{PLIST_NAME}.plist")

  # simple shell helper
  def shell(cmd)
    puts cmd
    res = `#{cmd}`.chomp
    puts res
    res
  end
end
