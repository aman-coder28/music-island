import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
  PanelWindow {
    id: root

    readonly property var activePlayer: {
      for (var i = 0; i < Mpris.players.values.length; i++) {
        if (Mpris.players.values[i].isPlaying)
          return Mpris.players.values[i];
      }
      return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null;
    }

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
      property bool playing: MprisPlaybackState.Playing

      color: Colors.secondayColor
      radius: Math.min(height / 2, 12)
      clip: true
      opacity: root.activePlayer !== null && root.activePlayer.isPlaying ? 1 : 0
      implicitWidth: expanded ? musicRow.implicitWidth + 300 : musicRow.implicitWidth + 30
      implicitHeight: expanded ? 130 : 33
      width: expanded ? musicRow.implicitWidth + 300 : musicRow.implicitWidth + 30
      height: expanded ? 130 : 33
      state: root.activePlayer !== null && root.activePlayer.isPlaying ? "shown" : "hidden"

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
            target: root
            width: musicRow.implicitWidth + 300
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
        topMargin: 4
      }

      Row {
        id: musicRow

        spacing: 6
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

            source: root.activePlayer.trackArtUrl ?? ""
            fillMode: Image.PreserveAspectCrop

            anchors {
              fill: parent
            }
          }
        }

        Text {
          text: root.activePlayer ? (root.activePlayer.trackTitle || "Unknown Title") : ""
          font.pixelSize: 14
          font.weight: 600
          font.family: "Inter"
          opacity: musicRect.expanded ? 0 : 1
          color: Colors.accentColor

          Behavior on opacity {
            NumberAnimation {
              duration: 150
            }
          }
        }
      }

      Column {
        spacing: 2
        opacity: musicRect.expanded ? 1 : 0

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
          text: root.activePlayer.trackArtist
          font.pixelSize: 18
          font.weight: 600
          font.family: "Inter"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primaryColor

          anchors {
            horizontalCenter: parent.horizontalCenter
          }
        }

        Text {
          text: root.activePlayer.trackTitle
          font.pixelSize: 14
          font.weight: 600
          font.family: "Inter"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primaryColor

          anchors {
            horizontalCenter: parent.horizontalCenter
          }
        }
      }
    }
  }
}
