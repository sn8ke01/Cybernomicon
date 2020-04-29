sleep 4
for (;;) {
            $wshell = new-object -ComObject wscript.shell;
            $wshell.AppActivate('Microsoft Outlook')
            sleep 1
            $wshell.sendkeys("{TAB}")
            $wshell.sendkeys("{TAB}")
            $wshell.sendkeys(" ")
            $wshell.sendkeys("{TAB}")
            $wshell.sendkeys("{TAB}")
            $wshell.sendkeys("{ENTER}")
            Sleep 61
            }