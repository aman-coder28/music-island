import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

    Rectangle {
      width: 120
      height: 120
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
          color: Colors.primaryColor
        }

        Text {
          text: Music.trackTitle
          font.pixelSize: 16
          font.weight: 600
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primaryColor
        }
      }

      Column {
        Text {
          text: "Track"
          font.pixelSize: 14
          font.weight: 350
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primaryColor
        }

        Text {
          text: Music.trackArtist
          font.pixelSize: 16
          font.weight: 600
          font.family: "JetBrains Mono"
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.primaryColor
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
      font.weight: 600
      font.family: "JetBrains Mono"
    }

    Item {
      Layout.fillWidth: true
      implicitHeight: 10

      Rectangle {
        id: rect1

        anchors.fill: parent
        color: "transparent"

        ProgressBar {
          id: pBar

          value: Music.position
          from: 0
          to: Music.length > 0 ? Music.length : 1

          background: Rectangle {
            implicitHeight: 10
            color: Colors.bgColor
            radius: 5
          }
          contentItem: Rectangle {
            implicitWidth: 200
            width: pBar.visualPosition * pBar.width
            implicitHeight: 10
            color: Colors.secondaryColor
            radius: 5
          }

          anchors {
            fill: parent
          }
        }
      }
    }

    Text {
      text: formatTime(Music.length)
      font.pixelSize: 13
      font.weight: 600
      font.family: "JetBrains Mono"
      color: "white"
    }
  }
}
