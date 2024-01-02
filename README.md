# WIP - not working yet

# Tidy Desktop

Very simple job to move Desktop files to `old` folder. 

```
git clone ...
cd ...
chmod +x install.rb
sudo ./install.rb
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
