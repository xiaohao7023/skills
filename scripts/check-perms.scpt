#!/usr/bin/env osascript

-- Check Accessibility Permission
-- Returns 0 if granted, 1 if not

try
    tell application "System Events"
        -- Try a harmless operation that requires accessibility
        set frontApp to name of first application process whose frontmost is true
        display notification "Accessibility permission is granted! Front app: " & frontApp with title "Shortcut Runner"
        return 0
    end tell
on error errMsg
    display notification "Accessibility permission needed. Please grant in System Settings." with title "Shortcut Runner"
    return 1
end try
