pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  readonly property int bars: 14
  property var levels: []
  property bool active: false
  property bool available: false
  property bool debug: true
  readonly property bool wanted: true

  // TOML format required for Cava 0.10+ (Fedora/RakuOS)
  // INI format for older Cava versions (Fedora/RakuOS default)
  readonly property string config: "[general]\n" + "bars = " + bars + "\n" + "framerate = 30\n" + "autosens = 0\n" + "sensitivity = 100\n" +   // <--- CHANGED FROM 5500 TO 150
  "\n" + "[input]\n" + "method = pulse\n" + "source = auto\n\n" + "[output]\n" + "method = raw\n" + "raw_target = /dev/stdout\n" + "data_format = ascii\n" + "ascii_max_range = 3000\n" + "bar_delimiter = 59\n" + "frame_delimiter = 10\n" + "channels = mono\n" + "mono_option = average\n\n" + "[smoothing]\n" + "noise_reduction = 77\n"

  // 1. Check if cava is installed
  Process {
    running: true
    command: ["sh", "-c", "command -v cava >/dev/null 2>&1"]

    onExited: code => {
      root.available = (code === 0);
      console.log("Cava available:", root.available);
      if (root.available && root.wanted) {
        cavaProc.running = true;
      }
    }
  }

  // 2. Run Cava with the TOML config file
  Process {
    id: cavaProc

    command: ["sh", "-c", "echo \"$1\" > /tmp/qs-cava.conf && cava -p /tmp/qs-cava.conf 2>&1", "_", root.config]

    stdout: SplitParser {
      onRead: line => {
        if (!line)
          return;

        if (root.debug)
          console.log("Cava raw line:", line);

        const parts = line.split(";");
        const out = [];
        let peak = 0;

        for (let i = 0; i < root.bars; i++) {
          const v = (parseInt(parts[i]) || 0) / 1000;
          out.push(v);
          if (v > peak)
            peak = v;
        }

        if (root.debug) {
          console.log("Cava levels:", out);
          console.log("Peak:", peak);
        }

        root.levels = out;

        if (peak > 0.02) {
          root.active = true;
          idle.restart();
        } else if (peak < 0.01) {
          root.active = false;
        }
      }
    }

    onExited: code => {
      console.log("Cava exited with code:", code);
      if (root.wanted)
        relaunch.restart();
    }
  }

  Timer {
    id: relaunch

    interval: 1500

    onTriggered: if (root.wanted)
      cavaProc.running = true
  }

  Timer {
    id: idle

    interval: 450

    onTriggered: root.active = false
  }
}
