#!/usr/bin/env osascript

-- Shortcut Runner for macOS
-- Usage: osascript run-shortcut.scpt <key1,key2,...> [delay] [target_app]

on run argv
    set keyList to {}
    set keyDelay to 0
    set targetApp to ""
    
    -- Parse arguments
    if (count of argv) > 0 then
        set keyString to item 1 of argv
        set keyList to my splitString(keyString, ",")
    else
        display dialog "Usage: osascript run-shortcut.scpt <key1,key2,...> [delay] [target_app]" buttons {"OK"} default button "OK"
        return
    end if
    
    if (count of argv) > 1 then
        set keyDelay to (item 2 of argv) as integer
    end if
    
    if (count of argv) > 2 then
        set targetApp to item 3 of argv
    end if
    
    -- Activate target app if specified
    if targetApp is not "" then
        try
            tell application targetApp to activate
            delay 0.2
        on error
            display notification "Could not activate " & targetApp with title "Shortcut Runner"
            return
        end try
    end if
    
    -- Execute keystrokes
    tell application "System Events"
        set modifierKeys to {}
        set mainKey to ""
        
        repeat with keyName in keyList
            set keyName to my normalizeKey(keyName)
            
            if keyName is in {"command", "control", "option", "shift"} then
                set end of modifierKeys to keyName
            else
                set mainKey to keyName
            end if
        end repeat
        
        -- Build keystroke command
        if (count of modifierKeys) > 0 and mainKey is not "" then
            -- Modifier + key combination
            set keyCmd to "keystroke " & my quoteString(mainKey) & " using {"
            repeat with i from 1 to (count of modifierKeys)
                if i > 1 then set keyCmd to keyCmd & ", "
                set keyCmd to keyCmd & (item i of modifierKeys) & " down"
            end repeat
            set keyCmd to keyCmd & "}"
            
            -- Execute using do script for dynamic command
            my executeKeystrokeWithModifiers(mainKey, modifierKeys)
            
        else if mainKey is not "" then
            -- Single key
            keystroke mainKey
        else if (count of modifierKeys) > 0 then
            -- Only modifiers (rare case)
            repeat with modKey in modifierKeys
                key down modKey
            end repeat
            delay 0.1
            repeat with modKey in modifierKeys
                key up modKey
            end repeat
        end if
        
        if keyDelay > 0 then delay (keyDelay / 1000)
    end tell
end run

-- Helper: Split string by delimiter
on splitString(theString, theDelimiter)
    set oldDelimiters to AppleScript's text item delimiters
    set AppleScript's text item delimiters to theDelimiter
    set theArray to text items of theString
    set AppleScript's text item delimiters to oldDelimiters
    return theArray
end splitString

-- Helper: Normalize key names
on normalizeKey(keyName)
    set keyName to my toLowercase(keyName)
    
    -- Modifier aliases
    if keyName is in {"cmd", "command", "⌘"} then return "command"
    if keyName is in {"ctrl", "control", "⌃"} then return "control"
    if keyName is in {"opt", "option", "alt", "⌥"} then return "option"
    if keyName is in {"shift", "⇧"} then return "shift"
    
    -- Special keys
    if keyName is in {"return", "enter"} then return return
    if keyName is "space" then return space
    if keyName is "tab" then return tab
    if keyName is in {"esc", "escape"} then return escape
    if keyName is in {"delete", "backspace"} then return delete
    if keyName is in {"up", "down", "left", "right"} then return keyName
    
    -- Function keys and literals pass through
    return keyName
end normalizeKey

-- Helper: Convert to lowercase
on toLowercase(str)
    set lowerStr to ""
    repeat with char in str
        set charCode to (ASCII number char)
        if charCode ≥ 65 and charCode ≤ 90 then
            set lowerStr to lowerStr & (ASCII character (charCode + 32))
        else
            set lowerStr to lowerStr & char
        end if
    end repeat
    return lowerStr
end toLowercase

-- Helper: Quote string for AppleScript
on quoteString(str)
    return "\"" & str & "\""
end quoteString

-- Execute keystroke with modifiers
on executeKeystrokeWithModifiers(mainKey, modifierKeys)
    tell application "System Events"
        if (count of modifierKeys) is 1 then
            set mod1 to item 1 of modifierKeys
            if mod1 is "command" then
                keystroke mainKey using command down
            else if mod1 is "control" then
                keystroke mainKey using control down
            else if mod1 is "option" then
                keystroke mainKey using option down
            else if mod1 is "shift" then
                keystroke mainKey using shift down
            end if
        else if (count of modifierKeys) is 2 then
            set mod1 to item 1 of modifierKeys
            set mod2 to item 2 of modifierKeys
            keystroke mainKey using {my keyToConstant(mod1), my keyToConstant(mod2)}
        else if (count of modifierKeys) is 3 then
            set mod1 to item 1 of modifierKeys
            set mod2 to item 2 of modifierKeys
            set mod3 to item 3 of modifierKeys
            keystroke mainKey using {my keyToConstant(mod1), my keyToConstant(mod2), my keyToConstant(mod3)}
        else if (count of modifierKeys) is 4 then
            keystroke mainKey using {command down, control down, option down, shift down}
        end if
    end tell
end executeKeystrokeWithModifiers

-- Convert key name to AppleScript constant
on keyToConstant(keyName)
    if keyName is "command" then return command down
    if keyName is "control" then return control down
    if keyName is "option" then return option down
    if keyName is "shift" then return shift down
    return command down
end keyToConstant
