import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root

  implicitWidth: 80
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  color: "transparent"

  mask: Region {
    item: clockRect
  }

  anchors {
    top: true
    left: true
    right: true
  }

  Rectangle {
    id: clockRect

    property bool expanded: hover.hovered

    color: Colors.secondayColor
    radius: Math.min(height / 2, 12)
    clip: true
    implicitWidth: expanded ? 200 : 90
    implicitHeight: expanded ? 100 : 34

    Behavior on implicitWidth {
      NumberAnimation {
        duration: 300
        easing.type: Easing.Bezier
        easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
      }
    }
    Behavior on implicitHeight {
      NumberAnimation {
        duration: 300
        easing.type: Easing.Bezier
        easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
      }
    }

    HoverHandler {
      id: hover
    }

    anchors {
      top: parent.top
      horizontalCenter: parent.horizontalCenter
      topMargin: 4
    }

    SystemClock {
      id: clock

      precision: SystemClock.Minutes
    }

    Text {
      text: Qt.formatTime(clock.date, "h:m A")
      font.pixelSize: 13
      font.weight: 600
      opacity: clockRect.expanded ? 0 : 1
      color: Colors.accentColor

      Behavior on opacity {
        NumberAnimation {
          duration: 120
        }
      }

      anchors {
        centerIn: parent
      }
    }

    Column {
      spacing: 4
      opacity: clockRect.expanded ? 1 : 0

      Behavior on opacity {
        NumberAnimation {
          duration: 200
          easing.type: Easing.Bezier
          easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
        }
      }

      anchors {
        centerIn: parent
      }

      Text {
        text: Qt.formatTime(clock.date, "h:m A")
        font.pixelSize: 22
        font.weight: 600
        opacity: clockRect.expanded ? 1 : 0
        color: Colors.primaryColor

        anchors {
          horizontalCenter: parent.horizontalCenter
        }
      }

      Text {
        text: Qt.formatDate(clock.date, "ddd, MMM d, yyyy")
        font.pixelSize: 14
        font.weight: 600
        opacity: clockRect.expanded ? 1 : 0
        color: Colors.primaryColor

        anchors {
          horizontalCenter: parent.horizontalCenter
        }
      }
    }
  }
}
