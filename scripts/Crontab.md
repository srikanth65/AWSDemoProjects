**cron**

cron is a time-based scheduling utility program. It can launch routine background jobs at specific times and/or days on an ongoing basis. cron is driven by a configuration file called /etc/crontab (cron table), which contains the various shell commands that need to be run at the properly scheduled times. There are both system-wide crontab files and individual user-based ones. Each line of a crontab file represents a job, and is composed of a so-called CRON expression, followed by a shell command to execute.

Typing crontab -e will open the crontab editor to edit existing jobs or to create new jobs. Each line of the crontab file will contain 6 fields: 

 
Table: Fields, Descriptions, Values
Field	Description	Values
MIN	Minutes	0 to 59
HOUR	Hour field	0 to 23
DOM	Day of Month	1-31
MON	Month field	1-12
DOW	Day of Week	0-6 (0 = Sunday)
CMD	Command	Any command to be executed
 

Examples:

The entry * * * * * /usr/local/bin/execute/this/script.sh will schedule a job to execute script.sh every minute of every hour of every day of the month, and every month and every day in the week.

The entry 30 08 10 06 * /home/sysadmin/full-backup will schedule a full-backup at 8.30 a.m., 10-June, irrespective of the day of the week.


**anacron**

While cron has been used in UNIX-like operating systems for decades, modern Linux distributions have moved over to a newer facility: anacron. This was because cron implicitly assumed the machine was always running. However, If the machine was powered off, scheduled jobs would not run. anacron will run the necessary jobs in a controlled and staggered manner when the system is up and running.

The key configuration file is /etc/anacrontab:

Note that anacron still makes use of the cron infrastructure for submitting jobs on a daily, weekly, and monthly basis, but it defers running them until opportune times when the system is actually alive.

**Sleep**

sleep suspends execution for at least the specified period of time, which can be given as the number of seconds (the default), minutes, hours, or days. After that time has passed (or an interrupting signal has been received), execution will resume.

The syntax is:

sleep NUMBER[SUFFIX]...

where SUFFIX may be:

s for seconds (the default)
m for minutes
h for hours
d for days.
sleep and at are quite different; sleep delays execution for a specific period, while at starts execution at a specific designated later time.



**Task**

**Task: Using at for Batch Processing in the Future**
 
Schedule a very simple task to run at a future time from now. This can be as simple as running ls or date and saving the output. You can use a time as short as one minute in the future.

Note that the command will run in the directory from which you schedule it with at.

Do this:

- From a short bash script.
- Interactively.

**Solutions**

Create the file testat.sh containing:

#!/bin/bash
date > /tmp/datestamp

and then make it executable and queue it up with at:

$ chmod +x testat.sh
$ at now + 1 minute -f testat.sh

You can see if the job is queued up to run with atq:

$ atq
17      Wed Apr 22 08:55:00 2015 a student

Make sure the job actually ran:

$ cat /tmp/datestamp
Wed Apr 22 08:55:00 CDT 2015

What happens if you take the /tmp/datestamp out of the command? Hint: Type mail if not prompted to do so!

Interactively, it is basically the same procedure. Just queue up the job with:

$ at now + 1 minute
at> date > /tmp/datestamp
CTRL-D
$ atq

**Task: Starting Processes in the Future**

**Task:** Set up a cron job to do some simple task every day at 10 a.m.

Set up a cron job to do a simple task every day at 10 AM. Create a file named mycrontab with the following content:

0 10 * * * /tmp/myjob.sh

and then create /tmp/myjob.sh containing:

#!/bin/bash
echo Hello I am running $0 at $(date)

and make it executable:

$ chmod +x /tmp/myjob.sh

Put it in the crontab system with:

$ crontab mycrontab

and verify it was loaded with:

$ crontab -l

0 10 * * * /tmp/myjob.sh

$ sudo ls -l /var/spool/cron/student

-rw------- 1 student student 25 Apr 22 09:59 /var/spool/cron/student

$ sudo cat /var/spool/cron/student

0 10 * * * /tmp/myjob.sh

NOTE: If you don't really want this running every day, printing out messages like:

Hello I am running /tmp/myjob.sh at Wed Apr 22 10:03:48 CDT 2015

and mailing them to you, you can remove it with:

$ crontab -r

If the machine is not up at 10 AM on a given day, anacron will run the job at a suitable time.
