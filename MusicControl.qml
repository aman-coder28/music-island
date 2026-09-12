import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets

Column {
  spacing: 18

  anchors {
    fill: parent
    margins: 20
  }

  Row {
    opacity: musicRect.expanded ? 1 : 0
    spacing: 25

    ClippingRectangle {
      width: 70
      height: 70
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
        spacing: 4

        Text {
          text: Music.trackTitle
          font.pixelSize: 15
          font.weight: 500
          font.family: "Inter"
          font.letterSpacing: 0.5
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.secondary
        }

        Text {
          text: Music.trackArtist
          font.pixelSize: 14
          font.weight: 400
          font.family: "Inter"
          font.letterSpacing: 0.5
          opacity: musicRect.expanded ? 1 : 0
          color: Colors.secondary
        }
      }
    }
  }

  Column {
    opacity: musicRect.expanded ? 1 : 0
    spacing: 10

    anchors {
      fill: parent
      topMargin: 10
    }

    Rectangle {
      id: rect1

      anchors.fill: parent
      color: "transparent"

      Slider {
        id: pBar

        anchors.fill: parent
        from: 0
        to: Music.length > 0 ? Music.length : 1

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
          if (!pressed) {
            Music.seekTo(value);
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

    Column {
      anchors.fill: parent

      RowLayout {
        Layout.fillWidth: parent

        Text {
          text: Music.formatTime(pBar.pressed ? pBar.value : Music.position)
          font.pixelSize: 13
          color: "white"
          font.weight: 400
          font.family: "Inter"
          font.letterSpacing: 1
        }

        Item {}

        Text {
          text: Music.formatTime(Music.length)
          font.pixelSize: 13
          font.weight: 400
          font.family: "Inter"
          font.letterSpacing: 1
          color: "white"
        }
      }
    }
  }

  RowLayout {
    Layout.alignment: Qt.AlignBottom
    Layout.fillWidth: parent.width
    Layout.fillHeight: parent.height
    spacing: 20

    Rectangle {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 20
      Layout.alignment: Qt.AlignHCenter
      radius: 8
      color: Music.activePlayer && Music.activePlayer.loopState !== MprisLoopState.None ? Colors.secondary_container : "transparent"

      Image {
        source: "assets/repeat.svg"
        width: 20
        height: 20
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: Music.cycleLoop()
      }
    }

    Rectangle {
      Layout.preferredWidth: 24
      Layout.preferredHeight: 24
      Layout.alignment: Qt.AlignVCenter
      radius: 8
      color: "transparent"

      Image {
        source: "assets/skip_previous.svg"
        width: 24
        height: 24
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.canGoPrevious)
            Music.activePlayer.previous();
        }
      }
    }

    Rectangle {
      id: playBtn

      Layout.preferredWidth: 42
      Layout.preferredHeight: 42
      Layout.alignment: Qt.AlignCenter
      radius: 11
      color: Colors.secondary_container

      Image {
        source: Music.activePlayer && Music.activePlayer.isPlaying ? "assets/pause.svg" : "assets/play.svg"
        width: 24
        height: 24

        anchors {
          centerIn: parent
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.canTogglePlaying)
            Music.activePlayer.togglePlaying();
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 24
      Layout.preferredHeight: 24
      Layout.alignment: Qt.AlignVCenter
      radius: 8
      color: "transparent"

      Image {
        source: "assets/skip_next.svg"
        width: 24
        height: 24
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.canGoNext)
            Music.activePlayer.next();
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 20
      Layout.alignment: Qt.AlignVCenter
      radius: 8
      color: Music.activePlayer && Music.activePlayer.shuffle ? Colors.secondary_container : "transparent"

      Image {
        source: "assets/shuffle.svg"
        width: 20
        height: 20
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.shuffleSupported)
            Music.activePlayer.shuffle = !Music.activePlayer.shuffle;
        }
      }
    }
  }
}
