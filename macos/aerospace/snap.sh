#!/bin/sh
# Snap the focused window: snap.sh left|right|full
# Uses macOS's own Window > Move & Resize (animated); falls back to an instant resize
# for apps without that menu.
# ponytail: fallback uses NSScreen.mainScreen (focused screen); multi-monitor edge cases untested
osascript -l JavaScript - "$1" <<'EOF'
ObjC.import("AppKit");
function run(argv) {
  const proc = Application("System Events").processes.whose({ frontmost: true })[0];
  try {
    proc.menuBars[0].menuBarItems.byName("Window").menus[0]
      .menuItems.byName("Move & Resize").menus[0]
      .menuItems.byName({ left: "Left", right: "Right", full: "Fill" }[argv[0]]).click();
    return;
  } catch (e) {}
  const v = $.NSScreen.mainScreen.visibleFrame;
  const top = $.NSScreen.screens.objectAtIndex(0).frame.size.height - (v.origin.y + v.size.height);
  let x = v.origin.x, w = v.size.width;
  if (argv[0] !== "full") { w = Math.floor(w / 2); if (argv[0] === "right") x += w; }
  const win = proc.windows[0];
  win.position = [x, top];
  win.size = [w, v.size.height];
}
EOF
