-- 飞书消息发送脚本
-- 使用方法: osascript send_message.scpt

on run
    -- 配置区域 - 修改以下变量
    set groupName to "三多需求团"          -- 群聊名称
    set messageContent to "你好，这是测试消息"  -- 消息内容
    
    -- 主流程
    tell application "System Events"
        -- 1. 打开飞书
        do shell script "open -a Lark"
        delay 0.5
        
        -- 2. 激活搜索 (Cmd+K)
        keystroke "k" using command down
        delay 0.3
        
        -- 3. 输入群名（剪贴板方案，支持中文）
        set the clipboard to groupName
        keystroke "v" using command down
        delay 0.3
        keystroke return
        delay 0.5
        
        -- 4. 输入消息内容（剪贴板方案，支持中文）
        set the clipboard to messageContent
        keystroke "v" using command down
        delay 0.2
        
        -- 5. 发送
        keystroke return
    end tell
    
    return "消息发送成功"
end run
