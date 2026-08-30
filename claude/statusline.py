#!/usr/bin/env python3
"""Claude Code status line.

Reads the status JSON from stdin and prints a single line showing:
  <dir> <git-branch> | <model> | <effort> | <bar> NN% (used/limit)

Context usage comes from the harness-provided `context_window` block when
present, falling back to the most recent assistant message's token usage in
the session transcript (input + cache-read + cache-creation). With nothing
to read yet (fresh session, before the first message) it renders 0%.
Everything is wrapped in try/except so a parse error degrades gracefully
instead of blanking the status line.
"""
import json
import os
import subprocess
import sys

# ---- ANSI helpers -----------------------------------------------------------
def c(code):
    return f"\033[{code}m"

RESET = c(0)
DIM = c(2)
BOLD = c(1)
BLUE = c(34)
CYAN = c(36)
MAGENTA = c(35)
GREEN = c(32)
YELLOW = c(33)
RED = c(31)
SEP = f" {DIM}|{RESET} "


def read_input():
    try:
        return json.load(sys.stdin)
    except Exception:
        return {}


def git_branch(cwd):
    try:
        out = subprocess.run(
            ["git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True, text=True, timeout=1,
        )
        if out.returncode == 0:
            b = out.stdout.strip()
            return b if b != "HEAD" else "detached"
    except Exception:
        pass
    return None


def context_used(transcript_path):
    """Return the current context-window token count, or None."""
    try:
        used = None
        with open(transcript_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    obj = json.loads(line)
                except Exception:
                    continue
                usage = (obj.get("message") or {}).get("usage")
                if not usage:
                    continue
                total = (
                    usage.get("input_tokens", 0)
                    + usage.get("cache_read_input_tokens", 0)
                    + usage.get("cache_creation_input_tokens", 0)
                )
                if total:
                    used = total  # keep the most recent non-zero reading
        return used
    except Exception:
        return None


def context_limit(model_id):
    mid = (model_id or "").lower()
    if "1m" in mid:
        return 1_000_000
    return 200_000


EFFORT_COLORS = {
    "low": GREEN,
    "medium": CYAN,
    "high": YELLOW,
    "max": RED,
}


def effort_label(data):
    """Current effort level, e.g. 'high'. None if the harness didn't say."""
    try:
        level = (data.get("effort") or {}).get("level")
        if not level:
            return None
        color = EFFORT_COLORS.get(str(level).lower(), MAGENTA)
        return f"{color}{level}{RESET}"
    except Exception:
        return None


def human(n):
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n/1_000:.0f}k"
    return str(n)


def bar(pct, width=10):
    filled = int(round(pct / 100 * width))
    filled = max(0, min(width, filled))
    if pct < 60:
        color = GREEN
    elif pct < 85:
        color = YELLOW
    else:
        color = RED
    return f"{color}{'█' * filled}{DIM}{'░' * (width - filled)}{RESET}", color


def main():
    data = read_input()

    cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or os.getcwd()
    model = (data.get("model") or {}).get("display_name") or "Claude"
    model_id = (data.get("model") or {}).get("id") or ""
    transcript = data.get("transcript_path")
    cost = (data.get("cost") or {}).get("total_cost_usd")

    parts = []

    # directory
    parts.append(f"{BOLD}{BLUE}{os.path.basename(cwd.rstrip('/')) or '/'}{RESET}")

    # git branch
    branch = git_branch(cwd)
    if branch:
        parts.append(f"{MAGENTA}{branch}{RESET}")

    line = f" {DIM}·{RESET} ".join(parts)

    # model
    line += SEP + f"{CYAN}{model}{RESET}"

    # effort
    effort = effort_label(data)
    if effort:
        line += SEP + effort

    # context — harness numbers first, transcript as fallback, 0% if neither.
    cw = data.get("context_window") or {}
    limit = cw.get("context_window_size") or context_limit(model_id)
    used = cw.get("total_input_tokens")
    if used is None:
        usage = cw.get("current_usage") or {}
        if usage:
            used = (
                usage.get("input_tokens", 0)
                + usage.get("cache_read_input_tokens", 0)
                + usage.get("cache_creation_input_tokens", 0)
            )
    if used is None and transcript:
        used = context_used(transcript)
    used = used or 0
    pct = min(100, used / limit * 100) if limit else 0
    b, color = bar(pct)
    line += SEP + f"{b} {color}{pct:.0f}%{RESET} {DIM}({human(used)}/{human(limit)}){RESET}"

    sys.stdout.write(line)


if __name__ == "__main__":
    main()
