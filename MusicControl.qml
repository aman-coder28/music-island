import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Column {
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
    spacing: 2

    anchors {
      leftMargin: 10
      rightMargin: 10
      fill: parent
      topMargin: 145
    }

    Text {
      text: "0" + Qt.locale().toString(Music.position / 60).substring(0, 1) + ":" + Qt.locale().toString(Music.position / 60).substring(2, 4)
      font.pixelSize: 13
      color: "white"
      font.weight: 600
      font.family: "JetBrains Mono"
    }

    Item {
      width: 200
      height: 10

      Rectangle {
        id: rect1

        anchors.fill: parent
        color: "transparent"

        ProgressBar {
          id: pBar

          value: Music.position
          from: 0
          to: Music.length

          background: Rectangle {
            implicitWidth: 200
            implicitHeight: 10
            color: Colors.bgColor
            radius: 5
          }
          contentItem: Rectangle {
            implicitWidth: 200
            width: pBar.visualPosition * parent.width
            implicitHeight: 10
            color: Colors.secondaryColor
            radius: 5
          }
        }
      }
    }

    Text {
      text: "0" + Qt.locale().toString(Music.length / 60).substring(0, 1) + ":" + Qt.locale().toString(Music.length / 60).substring(2, 4)
      font.pixelSize: 13
      font.weight: 600
      font.family: "JetBrains Mono"
      color: "white"
    }
  }
}
