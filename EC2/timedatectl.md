**How to set the time to local zone**

date # give the date and time in UTC

timedatectl    # give local time, universal time, etc

timedatectl list-timezones     #list the timezones

timedatectl set-timezone America/Vancouver      # this sets the time zone




**We change the time also but it's not recommended as system clock synchronized,**

timedatectl set-ntp off

timedatectl set-time 16:21:07

timedatectl set-ntp on # this will syn back to system clock

