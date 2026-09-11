import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root

  implicitHeight: 33
  implicitWidth: 80
  width: 80
  height: 33
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  color: "transparent"

  anchors {
    top: true
  }

  margins {
    top: 4
  }

  Rectangle {
    id: clockRect

    color: Colors.secondayColor
    radius: 8
    width: parent.width
    height: parent.height
    clip: false

    anchors {
      centerIn: parent
      fill: parent
    }

    Text {
      anchors.centerIn: parent
      text: Qt.formatTime(new Date(), "h:m A")
      font.pixelSize: 13
      font.weight: 500
      color: Colors.accentColor
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onEntered: {
        root.implicitWidth = 250;
        root.implicitHeight = 120;
      }
      onExited: {
        root.implicitWidth = 75;
        root.implicitHeight = 33;
      }
    }
  }
}
