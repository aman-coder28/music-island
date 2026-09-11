pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  property bool playing: MprisPlaybackState.Playing
  property bool paused: MprisPlaybackState.Paused
  property bool stopped: MprisPlaybackState.Stopped
  readonly property var activePlayer: {
    for (var i = 0; i < Mpris.players.values.length; i++) {
      if (Mpris.players.values[i].isPlaying)
        return Mpris.players.values[i];
    }
    return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null;
  }
  property string trackTitle: Music.activePlayer.trackTitle ?? ""
  property string albumArt: Music.activePlayer.trackArtUrl ?? ""
  property string trackArtist: Music.activePlayer.trackArtist ?? ""
  property real position: activePlayer.position
  property real length: activePlayer.length

  Timer {
    running: Music.activePlayer.playbackState == MprisPlaybackState.Playing
    interval: 1000
    repeat: true

    onTriggered: {
      Music.activePlayer.positionChanged();
    }
  }
}
