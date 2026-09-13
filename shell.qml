import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
  PanelWindow {
    id: root

    implicitWidth: 120
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    mask: Region {
      item: musicRect
    }

    anchors {
      top: true
      left: true
      right: true
      bottom: true
    }

    Rectangle {
      id: musicRect

      property bool expanded: hover.hovered

      color: Colors.on_secondary
      radius: expanded ? Math.min(height / 2, 16) : Math.min(height / 2, 8)
      clip: true
      opacity: Music.activePlayer !== null && Music.activePlayer.isPlaying ? 1 : 0
      implicitWidth: expanded ? 400 : musicRow.implicitWidth + 28
      implicitHeight: expanded ? musicRow.implicitHeight + 145 : 31
      width: expanded ? 400 : musicRow.implicitWidth + 28
      height: expanded ? musicRow.implicitHeight + 145 : 31
      state: Music.activePlayer !== null && Music.activePlayer.isPlaying ? "shown" : "hidden"

      Behavior on opacity {
        NumberAnimation {
          duration: 200
          easing.type: Easing.InOutElastic
        }
      }
      Behavior on width {
        NumberAnimation {
          duration: 300
          easing.type: Easing.Bezier
          easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
        }
      }
      Behavior on height {
        NumberAnimation {
          duration: 300
          easing.type: Easing.Bezier
          easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
        }
      }
      states: [
        State {
          name: "shown"

          PropertyChanges {
            target: musicRect
            width: musicRect.expanded ? 380 : musicRow.width + 28
            opacity: 1
            visible: true
          }
        },
        State {
          name: "hidden"

          PropertyChanges {
            target: musicRect
            width: 0
            opacity: 0
            visible: false
          }
        }
      ]
      transitions: [
        Transition {
          from: "shown"
          to: "hidden"

          SequentialAnimation {
            NumberAnimation {
              properties: "width,opacity"
              duration: 250
              easing.type: Easing.InCubic
            }

            PropertyAction {
              property: "visible"
            }
          }
        },
        Transition {
          from: "hidden"
          to: "shown"

          SequentialAnimation {
            PropertyAction {
              property: "visible"
            }

            NumberAnimation {
              properties: "width,opacity"
              duration: 250
              easing.type: Easing.OutCubic
            }
          }
        }
      ]

      HoverHandler {
        id: hover
      }

      anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
        topMargin: expanded ? 6 : 2
      }

      Row {
        id: musicRow

        spacing: 8
        opacity: musicRect.expanded ? 0 : 1

        anchors {
          centerIn: parent
        }

        ClippingRectangle {
          width: 20
          height: 20
          radius: 180
          opacity: musicRect.expanded ? 0 : 1

          Image {
            id: musicImage

            source: Music.albumArt ?? ""
            fillMode: Image.PreserveAspectCrop

            anchors {
              fill: parent
            }
          }
        }

        Text {
          text: Music.shortenStrings(Music.activePlayer ? (Music.trackTitle || "Unknown Title") : "")
          font.pixelSize: 14
          font.weight: 600
          font.family: "Inter"
          opacity: musicRect.expanded ? 0 : 1
          color: Colors.on_surface

          Behavior on opacity {
            NumberAnimation {
              duration: 150
            }
          }
        }
      }

      MusicControl {}
    }
  }
}
