# Tidy Desktop

Very simple job to move Desktop files to `old` folder. This will move files
(not folders) older than 30 minutes to a desktop folder
`old/tidy-desktop-yyyy-mm-dd`

This runs in crontab on Mac OS. This assumes you know how to use basic Terminal
commands.

```
git clone https://github.com/wiseleyb/tidy-desktop
cd tidy-desktop
chmod a+x tidy-desktop.rb
chmod a+x install.rb
./install.rb
```

This will create a `config.yml` by asking some basic questions and spit out a
string that needs to be copy/pasted (without line breaks) into crontab.

Example:
```
Add to cron tab
If the script ran as expected you just need to add this to cron.
Use "crontab -e" to add this line.


*/15 * * * * /Users/benwiseley/.asdf/installs/ruby/3.2.2/bin/ruby /Users/benwiseley/dev/tidy-desktop/tidy-desktop.rb  >> /Users/benwiseley/dev/tidy-desktop/tidy-desktop.log 2>&1
```

You then just need to copy the last line above and paste it into crontab -e

```
cronttab -e
{paste in line}
```

# Debugging

After doing install above you can test if tidy-desktop runs by doing
`./tidy-desktop` from the source code directory.

Or you can tail the log to see if cron is running (it should output something
every 15 minutes.

```
tail -f tidy-desktop.log
```

And you'll see something like every 15 minutes or so (or the files it moved)

```
0 moved at 2024-01-03 11:47:00 -0800
```

# Crontab

You can play around with cron strings using
this tool: [crontab-generator](https://crontab-generator.org/)

You can see what is in cront with `crontab -l`

