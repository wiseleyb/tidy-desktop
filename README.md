# Tidy Desktop

Very simple job to move Desktop files to `old` folder. 

# Crontab

```
git clone https://github.com/wiseleyb/tidy-desktop
cd tidy-desktop
chmod a+x tidy-desktop.rb
crontab -e 
```

Add this to run every 15 minutes.  You can play around with cron strings using
this tool: [crontab-generator](https://crontab-generator.org/)

```
*/15 * * * * /Users/benwiseley/.asdf/shims/ruby /Users/benwiseley/dev/tidy-desktop/tidy-desktop.rb >> /Users/benwiseley/dev/tidy-desktop/tidy-desktop.log 2>&1
```

You can see what is in cront with `crontab -l`

# LaunchCtl - not working yet

```
git clone ...
cd ...
chmod a+x install.rb
sudo ./install.rb
sudo -E `asdf which ruby` install.rb
```

# Turning on/off

* Open `System Settings`
* Search for 'Login Items' and click `Open at Login` 
* You should see `com.wiseleyb.tidy.desktop`

# Debugging

From [launchd.info](https://www.launchd.info/)

Run this:

```
sudo tail -F /var/log/system.log | grep --line-buffered "com.apple.launchd\[" | grep "com.wiseleyb.tidy.desktop"
```

Then run the install script

