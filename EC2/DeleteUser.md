
id srisri   # Check if user exists

pkill -u srisri  # Kill any running processes by that user (important before deletion)

userdel srisri   # Delete the user but keep home directory and files

userdel -r srisri   # Delete the user and also remove their home directory, mail spool, and files

sudo deluser --remove-home srisri  # on Ubuntu/Debian

id srisri    # Verify deletion

⚠️ Caution: If you delete with -r, it permanently removes /home/srisri and /var/mail/srisri. Make sure you don’t need the files.
