# logrotate

A simple docker container used to learn and experiment with
logrotate. It uses logrotate in a normal user account.

## Build and Run

To run it, clone the repository, build the docker image then run
it:

```bash
cd
git clone https://github.com/flenniken/logrotate.git logrotate
cd logrotate
docker build --rm -t logrotate .
docker run -t -i logrotate
```

## Sample Session

Here is a sample session showing my.log rolling over.

```bash
$ docker run -t -i logrotate
[ ok ] Starting periodic command scheduler: cron.
steve@047236d9601b:~$ ll
total 16
-rw-r--r-- 1 steve steve  13 Nov  8 05:02 my.log
-rw-r--r-- 1 steve steve 106 Nov 10 21:33 mycron
-rw-r--r-- 1 steve steve 193 Nov 10 21:20 rotate.conf
-rwxr-xr-x 1 steve steve 190 Nov 10 20:54 script.sh
steve@047236d9601b:~$ f
total 16
-rw-r--r-- 1 steve steve 1841 Nov 11 03:45 my.log
-rw-r--r-- 1 steve steve  106 Nov 10 21:33 mycron
-rw-r--r-- 1 steve steve  193 Nov 10 21:20 rotate.conf
-rwxr-xr-x 1 steve steve  190 Nov 10 20:54 script.sh
steve@047236d9601b:~$ r
total 20
-rw-r--r-- 1 steve steve 1841 Nov 11 03:45 my.log
-rw-r--r-- 1 steve steve  106 Nov 10 21:33 mycron
-rw-r--r-- 1 steve steve  193 Nov 10 21:20 rotate.conf
-rwxr-xr-x 1 steve steve  190 Nov 10 20:54 script.sh
-rw-r--r-- 1 steve steve   67 Nov 11 03:45 state.txt
steve@047236d9601b:~$ f
total 28
-rw-r--r-- 1 steve steve 9806 Nov 11 03:45 my.log
-rw-r--r-- 1 steve steve  106 Nov 10 21:33 mycron
-rw-r--r-- 1 steve steve  193 Nov 10 21:20 rotate.conf
-rwxr-xr-x 1 steve steve  190 Nov 10 20:54 script.sh
-rw-r--r-- 1 steve steve   67 Nov 11 03:45 state.txt
steve@047236d9601b:~$ r
total 20
-rw-r--r-- 1 steve steve    0 Nov 11 03:45 my.log
-rw-r--r-- 1 steve steve 3325 Nov 11 03:45 my.log-2018-11-11.1541907944.gz
-rw-r--r-- 1 steve steve  106 Nov 10 21:33 mycron
-rw-r--r-- 1 steve steve  193 Nov 10 21:20 rotate.conf
-rwxr-xr-x 1 steve steve  190 Nov 10 20:54 script.sh
-rw-r--r-- 1 steve steve   69 Nov 11 03:45 state.txt
steve@047236d9601b:~$ exit
```


## Explore

The container has logrotate configured to rotate my.log. There are
four aliases defined to make it easy to explore how logrotate works.
You type f to fill my.log with text, then type r to run logrotate. Use
ll to list the files.

* ll -- list files
* f -- fill my.log with lorem ipsum paragraphs then list files
* t -- test run logrotate
* r -- run logrotate then list files

The aliases are defined in the .bashrc file.  You can see their
definitions with the alias command:

```bash
alias

alias f='lorem -p $(shuf -i 1-100 -n 1) >>my.log;ll'
alias t='logrotate -d -s /home/steve/state.txt /home/steve/rotate.conf'
alias r='logrotate -s /home/steve/state.txt /home/steve/rotate.conf;ll'
alias ll='ls -l'
```

## Modify

You can edit and view the configuration files:

```bash
nano rotate.conf
less rotate.conf
zless my.log-2018...
```

## Configuration

When logrotate runs it reads the configuration file specified on the
command line. The config file tells what files to rotate and how to
rotate them.  The configuration file contains comments, log filenames
and their directives. The rotate.conf is used in this docker
container.  The file looks like:

```
# Rotate my.log file.
/home/steve/my.log {
  notifempty
  compress
  dateext
  dateformat -%Y-%m-%d.%s
  create
  rotate 5
  size 2k
}
```

You can specify directives outside log file groups and they become the
defaults for the log files.  In this example there is only one file and
there is no need for defaults.

The "size 2k" directive rotates the file when the file size is over
2K, the compress directive compresses the file with gz and the dateext
and dateformat names the file with the current date.

## Cron

This container contains a cron job called mycron.  It runs the script.sh
file every minute and logs the time it ran to the cron.log file. You
can uncomment a line in it to run logrotate every minute.


## Files

* .bashrc -- contains the aliases, ll, f, t, r.
* cron.log -- the cron log file telling when the job ran
* my.log -- the log file that gets rotated
* my.log-2018-11-10.1541885686.gz -- a rotated compressed log (view with zless)
* mycron -- the cron job that runs script.sh every minute
* rotate.conf -- the logrotate configuration file for my.log
* script.sh -- the script run by the cron job
* state.txt -- log file written to by logrotate when it runs.

## More Information

The logrotate manual describes all the configuration directives.

```bash
man logrotate
```

The manual for crontab is also useful.  You can generate your cron
line from your browser:

* [Crontab Generator](https://crontab-generator.org/)
