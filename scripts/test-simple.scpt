#!/usr/bin/env osascript

-- Simple test: just press cmd+space (Spotlight)
-- This is a safe test that opens Spotlight search

try
    tell application "System Events"
        keystroke space using command down
    end tell
    return "SUCCESS: Spotlight opened (cmd+space worked)"
on error errMsg
    return "ERROR: " & errMsg & " - Need to grant Accessibility permission to openclaw-gateway"
end try
