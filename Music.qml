pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  property bool playing: MprisPlaybackState.Playing
  property bool paused: MprisPlaybackState.Paused
  property bool stopped: MprisPlaybackState.Stopped
  readonly property var activePlayer: {
    return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null;
  }
  property string trackTitle: Music.activePlayer.trackTitle ?? ""
  property string albumArt: Music.activePlayer.trackArtUrl ?? ""
  property string trackArtist: Music.activePlayer.trackArtist ?? ""
  property real position: activePlayer.position
  property real length: activePlayer.length

  Timer {
    running: Music.activePlayer.playbackState == MprisPlaybackState.Playing
    interval: 150
    repeat: true

    onTriggered: {
      Music.activePlayer.positionChanged();
    }
  }
}
