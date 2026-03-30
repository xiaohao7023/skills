#!/usr/bin/env python3
"""Create an Apple Calendar event from natural language input."""

import sys
import json
import subprocess
import re
from datetime import datetime, timedelta

try:
    import dateparser
    HAS_DATEPARSER = True
except ImportError:
    HAS_DATEPARSER = False


def apply_pm_modifier(hour: int, is_pm: bool) -> int:
    """Convert hour for afternoon/evening markers.
    Only applies adjustment for afternoon markers when hour < 12.
    Hour >= 12 is treated as already 24h format (e.g. '16点' = 16:00).
    """
    if is_pm:
        if hour < 12:
            return hour + 12  # 下午4点 → 16点
    else:
        if hour == 12:
            return 0  # 早上12点 → 0点
    return hour


def make_dt(base_date, hour, minute=0):
    return base_date.replace(hour=hour, minute=minute, second=0, microsecond=0)


def parse_datetime(text: str):
    """Parse natural language date/time from Chinese text."""
    text = text.strip()
    now = datetime.now()

    # Try dateparser first if available
    if HAS_DATEPARSER:
        dt = dateparser.parse(text, languages=['zh', 'en'])
        if dt:
            return dt

    def try_match(pattern, flags=0):
        return re.search(pattern, text, flags)

    # Pattern 1: 今天/明天/后天 + 下午/早上/etc + HH点MM
    p1 = r'(今天|明天|后天)\s*(下午|晚上|早上|中午|早|午|晚)?\s*(\d{1,2})点(\d{0,2})'
    m = try_match(p1)
    if m:
        day_word, period, hour_s, minute_s = m.groups()
        hour = int(hour_s)
        minute = int(minute_s) if minute_s else 0
        is_pm = period in ('下午', '晚上', '中午')
        h = apply_pm_modifier(hour, is_pm)
        if day_word == '今天':
            dt = make_dt(now, h, minute)
            if dt < now:
                dt += timedelta(days=1)
            return dt
        elif day_word == '明天':
            return make_dt(now + timedelta(days=1), h, minute)
        elif day_word == '后天':
            return make_dt(now + timedelta(days=2), h, minute)

    # Pattern 2: 仅时间，无日期前缀，如"下午16点40"
    # 直接用今天，如果时间已过则顺延到明天
    p2 = r'(下午|晚上|早上|中午|早|午|晚)?\s*(\d{1,2})点(\d{0,2})'
    m = try_match(p2)
    if m:
        period, hour_s, minute_s = m.groups()
        hour = int(hour_s)
        minute = int(minute_s) if minute_s else 0
        is_pm = period in ('下午', '晚上', '中午')
        h = apply_pm_modifier(hour, is_pm)
        dt = make_dt(now, h, minute)
        if dt < now:
            dt += timedelta(days=1)
        return dt

    # Pattern 3: 具体日期 2026年4月5日下午2点
    p3 = r'(\d{4})年(\d{1,2})月(\d{1,2})日\s*(下午|晚上|早上|中午|早|午|晚)?\s*(\d{1,2})点(\d{0,2})'
    m = try_match(p3)
    if m:
        y, mo, d, period, hour_s, minute_s = m.groups()
        hour = int(hour_s)
        minute = int(minute_s) if minute_s else 0
        is_pm = period in ('下午', '晚上', '中午')
        h = apply_pm_modifier(hour, is_pm)
        return datetime(int(y), int(mo), int(d), h, minute)

    return None


def extract_title(text: str) -> str:
    """Extract the event title from the input text."""
    # Remove time-related patterns
    text = re.sub(r'今天|明天|后天|\d{4}年\d{1,2}月\d{1,2}日', '', text)
    text = re.sub(r'[上下早晚中午?]*\s*\d{1,2}点\d{0,2}', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    text = re.sub(r'^(去|把|约|安排|创建|新建|添加|提醒我|提醒)\s+', '', text)
    return text or "日程"


def create_calendar_event(title: str, start_dt: datetime, end_dt: datetime = None, calendar_name: str = None):
    """Create an event in Apple Calendar using osascript."""
    if end_dt is None:
        end_dt = start_dt + timedelta(hours=1)

    if calendar_name is None:
        result = subprocess.run(
            ['osascript', '-e', 'tell application "Calendar" to return name of calendars'],
            capture_output=True, text=True
        )
        calendars = [c.strip() for c in result.stdout.strip().split(',')]
        calendar_name = calendars[0] if calendars else "Calendar"

    start_str = start_dt.strftime("%Y年%m月%d日 %H:%M:%S")
    end_str = end_dt.strftime("%Y年%m月%d日 %H:%M:%S")

    script = f'''
    tell application "Calendar"
        tell calendar "{calendar_name}"
            make new event with properties {{summary:"{title}", start date:date "{start_str}", end date:date "{end_str}"}}
        end tell
        save
    end tell
    '''

    result = subprocess.run(
        ['osascript'],
        input=script,
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        raise Exception(f"osascript error: {result.stderr}")

    return calendar_name, start_dt, end_dt


def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Usage: create_event.py <text> [calendar_name]"}))
        sys.exit(1)

    text = sys.argv[1]
    calendar_name = sys.argv[2] if len(sys.argv) > 2 else None
    title = extract_title(text)
    start_dt = parse_datetime(text)

    if not start_dt:
        print(json.dumps({"error": f"无法解析时间：{text}"}))
        sys.exit(1)

    end_dt = start_dt + timedelta(hours=1)

    try:
        cal_name, start, end = create_calendar_event(title, start_dt, end_dt, calendar_name)
        print(json.dumps({
            "success": True,
            "title": title,
            "calendar": cal_name,
            "start": start.isoformat(),
            "end": end.isoformat()
        }))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)


if __name__ == "__main__":
    main()
