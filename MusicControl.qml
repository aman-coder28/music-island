import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets

Column {
  function formatTime(totalSeconds) {
    var total = Math.max(0, Math.floor(totalSeconds));
    var minutes = Math.floor(total / 60);
    var seconds = total % 60;

    return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
  }

  anchors {
    fill: parent
    margins: 25
  }

  Row {
    opacity: musicRect.expanded ? 1 : 0
    spacing: 25

    ClippingRectangle {
      width: 120
      height: 120
      radius: 8
      color: "transparent"

      Image {
        id: musicImage

        source: Music.albumArt ?? ""
        fillMode: Image.PreserveAspectCrop

        anchors {
          fill: parent
        }
      }
    }

    Column {
      id: track

      spacing: 10
      opacity: musicRect.expanded ? 1 : 0
      topPadding: 8

      Behavior on opacity {
        NumberAnimation {
          duration: 200
          easing.type: Easing.Bezier
          easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
        }
      }

      Column {
        Text {
          text: "Artist"
          font.pixelSize: 14
          font.weight: 350
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primary
        }

        Text {
          text: Music.trackArtist
          font.pixelSize: 16
          font.weight: 600
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primary
        }
      }

      Column {
        Text {
          text: "Track"
          font.pixelSize: 14
          font.weight: 350
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primary
        }

        Text {
          text: Music.trackTitle
          font.pixelSize: 16
          font.weight: 600
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primary
        }
      }
    }
  }

  RowLayout {
    opacity: musicRect.expanded ? 1 : 0
    spacing: 10

    Behavior on opacity {
      NumberAnimation {
        duration: 300
        easing.type: Easing.InBounce
      }
    }

    anchors {
      fill: parent
      topMargin: 135
    }

    Text {
      text: formatTime(Music.position)
      font.pixelSize: 13
      color: "white"
      font.weight: 400
      font.family: "JetBrains Mono"
    }

    Item {
      Layout.fillWidth: true
      implicitHeight: 12

      Rectangle {
        id: rect1

        anchors.fill: parent
        color: "transparent"

        Slider {
          id: pBar

          anchors.fill: parent
          from: 0
          to: Music.length > 0 ? Music.length : 1
          value: Music.length > 0 ? Music.position / Music.length : 1

          background: Rectangle {
            x: pBar.leftPadding
            y: pBar.topPadding + pBar.availableHeight / 2 - height / 2
            width: pBar.availableWidth
            height: 10
            radius: height / 2
            color: Colors.surface_variant

            Rectangle {
              width: pBar.visualPosition * parent.width
              height: parent.height
              radius: height / 2
              color: Colors.secondary
            }
          }
          handle: Item {
            x: pBar.leftPadding + pBar.visualPosition * (pBar.availableWidth - width)
            y: pBar.topPadding + pBar.availableHeight / 2 - height / 2
            width: 17
            height: 17

            RectangularShadow {
              anchors.fill: parent
              radius: width / 2
              blur: 2
              spread: 1
              color: Colors.on_secondary
            }

            Rectangle {
              anchors.fill: parent
              radius: width / 2
              color: Colors.background
            }
          }

          onPressedChanged: {
            if (!pressed && Music.activePlayer && Music.activePlayer.canSeek) {
              Music.activePlayer.position = pBar.value;
            }

            if (pressed && Music.activePlayer && Music.activePlayer.canSeek) {
              Music.activePlayer.seek(value * Music.length);
            }
          }

          Binding {
            target: pBar
            property: "value"
            value: Music.position
            when: !pBar.pressed
          }
        }
      }
    }

    Text {
      text: formatTime(Music.length)
      font.pixelSize: 13
      font.weight: 400
      font.family: "JetBrains Mono"
      color: "white"
    }
  }
}
