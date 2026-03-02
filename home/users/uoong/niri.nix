{ pkgs, username, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                // You can set rules, model, layout, variant and options.
                // For more information, see xkeyboard-config(7).

                // For example:
                // layout "us,ru"
                // options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"

                // If this section is empty, niri will fetch xkb settings
                // from org.freedesktop.locale1. You can control these using
                // localectl set-x11-keymap.
            }

            numlock
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
        }

        trackpoint {
        }

    }

    output "eDP-1" {
        mode "1920x1200@60.001"
        scale 1.25
        transform "normal"
        position x=1920 y=0
    }
    output "HDMI-A-1" { // DELL
        mode "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=3200 y=0
    }
    output "DP-2" { // Lenovo
        mode "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=0 y=0
    }

    layout {
        background-color "transparent"
        gaps 16

        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }
        focus-ring {
            width 4

            active-color "#7fc8ff"

            inactive-color "#505050"

        }

        border {
            off

            width 4
            active-color "#ffc87f"
            inactive-color "#505050"

            urgent-color "#9b0000"

        }

        shadow {
            softness 30

            spread 5

            offset x=0 y=5

            color "#0007"
        }

        struts {
        }
    }

    hotkey-overlay {
        // Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
        // skip-at-startup
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    environment {
        XDG_DATA_DIRS "/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:/home/${username}/.local/share/flatpak/exports/share"
        XDG_SESSION_DESKTOP "niri"
        XDG_CURRENT_DESKTOP "niri"
        QT_IM_MODULE "fcitx"
        XMODIFIERS "@im=fcitx"
        LD_PRELOAD ""
        MOZ_ENABLE_WAYLAND "1"
        XDG_SESSION_TYPE "wayland"
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_DESKTOP "niri"
        MOZ_DBUS_REMOTE "1"
        GDK_BACKEND "wayland"
        QT_AUTO_SCREEN_SCALE_FACTOR "1"
        QT_WAYLAND_FORCE_DPI "physical"
        EGL_PLATFORM "wayland"
        CLUTTER_BACKEND "wayland"
        TERM "alacritty"
        TERMINAL "alacritty"
        _JAVA_AWT_WM_NONREPARENTING "1"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        QT_QPA_PLATFORMTHEME "qt6ct"
        EDITOR "hx"
    }

    animations {
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    window-rule {
      // Rounded corners for a modern look.
      geometry-corner-radius 10

      // Clips window contents to the rounded corner boundaries.
      clip-to-geometry true
    }

    debug {
      honor-xdg-activation-with-invalid-serial
    }

    layer-rule {
      match namespace="^noctalia-wallpaper*"
      place-within-backdrop true
    }
    overview {
      workspace-shadow {
        off
      }
    }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+Return hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
        Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+S { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        Mod+Comma { spawn "noctalia-shell" "ipc" "call" "settings" "toggle"; }

        // Audio controls
        XF86AudioRaiseVolume { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }

        // Brightness controls
        XF86MonBrightnessUp { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
        XF86MonBrightnessDown { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }

        // Utility shortcuts
        Mod+P { spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard"; }
        Super+Alt+L hotkey-overlay-title="Lock the Screen: noctalia-shell"{
            spawn-sh "qs -c noctalia-shell ipc call lockScreen lock && sleep 0.5 && niri msg action power-off-monitors";
        }
        Mod+E hotkey-overlay-title="Open file manager: Thunar" { spawn "thunar"; }
        Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }

        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

        // Example media keys mapping using playerctl.
        // This will work with any MPRIS-enabled media player.
        XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }

        Mod+O repeat=false { toggle-overview; }

        Mod+Q repeat=false { close-window; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }


        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        // horizontal scrolling; these binds replicate that.
        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+Period { expel-window-from-column; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        Mod+Ctrl+F { expand-column-to-available-width; }

        Mod+C { center-column; }

        // Center all fully visible columns on screen.
        Mod+Ctrl+C { center-visible-columns; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Finer height adjustments when in column with other windows.
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Move the focused window between the floating and the tiling layout.
        Mod+V       { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        Mod+W { toggle-column-tabbed-display; }


        Mod+A { screenshot; }
        Mod+Shift+A { spawn-sh "wl-paste | satty -f -"; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete { quit; }

        Mod+Shift+P { power-off-monitors; }
    }

  '';

}
