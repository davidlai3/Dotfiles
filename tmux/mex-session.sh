#!/bin/sh
# Rename the newest tmux session to the mex (lowest unused non-negative
# integer) of the existing session names. Run from the session-created hook.
# Sessions the user named explicitly are left alone.

# The session just created is the one with the highest session id.
n=$(tmux list-sessions -F '#{session_id}' 2>/dev/null | tr -d '$' | sort -n | tail -1)
[ -n "$n" ] || exit 0
sid="\$$n"

name=$(tmux display-message -p -t "$sid" '#{session_name}' 2>/dev/null)
# tmux auto-names a session after its numeric session id; leave real names alone
[ "$name" = "$n" ] || exit 0

i=0
while tmux has-session -t "=$i" 2>/dev/null && [ "$i" != "$name" ]; do
	i=$((i + 1))
done
[ "$i" = "$name" ] || tmux rename-session -t "$sid" "$i"
