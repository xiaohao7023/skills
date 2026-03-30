---
name: nl-calendar
description: 将自然语言日程消息自动写入苹果日历，并设置微信提醒。当用户发送含时间信息的日程消息时触发（如"明天下午2点去剪头发"）。
---

# NL Calendar Skill

将自然语言日程消息自动写入苹果日历（Calendar.app），并在日程开始时通过微信推送提醒。

## 配置项（必须）

使用前需要在 OpenClaw 配置文件中设置以下项：

```json
"skills": {
  "entries": {
    "nl-calendar": {
      "config": {
        "wechat_user_id": "你的微信用户ID",
        "wechat_account_id": "你的微信机器人accountId",
        "calendar_name": "生活"
      }
    }
  }
}
```

获取方式：
- `wechat_user_id`：微信对话的 `o9xxxx@im.wechat` 格式 ID（使用 /openclaw weixin debug 或查看插件日志）
- `wechat_account_id`：机器人的 account ID（配置在 openclaw-weixin 插件中）
- `calendar_name`：要写入的日历名称（默认"生活"）

## 执行步骤

### 步骤 1：解析并创建日历事件

运行脚本：

```bash
python3 ~/.openclaw/skills/nl-calendar/scripts/create_event.py "用户消息全文"
```

脚本输出 JSON：
```json
{"success": true, "title": "去剪头发", "calendar": "生活", "start": "2026-03-31T14:00:00", "end": "2026-03-31T15:00:00"}
```

若解析失败，回复用户：「时间没读懂，具体是什么时候？」

### 步骤 2：设置微信提醒 cron

根据脚本输出的 `start` 时间（ISO 格式），创建 cron job：

- `schedule.kind`: `"at"` — 精确到 start 时间（UTC）
- `payload.kind`: `"agentTurn"` — isolated session
- `payload.message`: 发送微信消息，格式：「📅 [标题] 开始了！」
- `delivery.mode`: `"announce"`
- `delivery.accountId`: 来自配置 `skills.entries.nl-calendar.config.wechat_account_id`
- `delivery.to`: 来自配置 `skills.entries.nl-calendar.config.wechat_user_id`
- `sessionTarget`: `"isolated"`
- `deleteAfterRun`: true

### 步骤 3：确认回复用户

格式：
```
✅ 日程已创建

📅 [标题]
📍 [日历名]
🕐 [开始时间 - 结束时间]
🔔 提醒已设置（[时间] 微信提醒）
```

## 时间解析支持格式

| 输入 | 解析结果 |
|------|---------|
| 明天下午2点 | 明天 14:00 |
| 今天下午3点半 | 今天 15:30 |
| 后天早上9点 | 后天 09:00 |
| 2026年4月5日14点 | 2026-04-05 14:00 |
| 下午16点50 | 今天 16:50（已过则顺延明天） |

## 日历创建细节

- 工具：`osascript` → Calendar.app
- 默认日历：`生活`（可通过 `calendar_name` 配置）
- 日程时长：默认1小时

## 微信提醒

- 提醒时间：日程开始时（准时）
- 消息格式：`📅 [日程标题] 开始了！`
- 使用 `message` 工具发送，channel=`openclaw-weixin`

## 依赖

- macOS + Calendar.app
- `openclaw-weixin` 插件（已配置账号）
- Python 3（内置 `osascript`）
