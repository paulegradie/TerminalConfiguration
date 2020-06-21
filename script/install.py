import sys;
from os.path import expanduser, join, exists, rename

# This script modifies the required files to reference .SettingsAndConfigurations instead of looking
# in their own paths.

# This script will replace the currentuser profile with

## Should simply source the content of ./SettingsAndConfigurations/WindowsTerminal/profle.ps1
# $USER = $env:USERPROFILE;. $USER\.SettingsAndConfigurations\WindowsTerminal\profile.ps1

HOME = expanduser("~");
DIR = "Documents\PowerShell"
FILENAME = "profile.ps1"

WINDOWS_CURRENTUSER_POWERSHELL_PROFILE = join(HOME, DIR, FILENAME)

def increment(oldpath):
    if oldpath.endswith('.bkup'):
        return oldpath.replace('.bkup', '.bkup-0')
    else:
        oldsuffix = oldpath.split('.')[-1]
        count = int(oldsuffix.split("-")[-1])
        count += 1
        newsuffix = "-".join([oldsuffix.split("-")[0], count])
        newpath = oldpath.replace(oldsuffix, newsuffix)
        return newpath

content = [
    """# Should simply source the content of ./SettingsAndConfigurations/WindowsTerminal/profle.ps1""",
    """$USER = $env:USERPROFILE;. $USER\.SettingsAndConfigurations\WindowsTerminal\profile.ps1"""
]
if sys.platform == 'win32': # windows machine
    if exists(WINDOWS_CURRENTUSER_POWERSHELL_PROFILE):
        newfile = join(HOME, DIR, 'profile.ps1.bkup')
        if not exists(newfile):
            rename(WINDOWS_CURRENTUSER_POWERSHELL_PROFILE, newfile)
        else:
            newfile = increment(newfile)
            rename(WINDOWS_CURRENTUSER_POWERSHELL_PROFILE, newfile)

    with open(WINDOWS_CURRENTUSER_POWERSHELL_PROFILE, 'w') as fout:
        for line in content:
            fout.write(line)

else:
    print(f"Current platform: {sys.platform} not supported for auto install.")