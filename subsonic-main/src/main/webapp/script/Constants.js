
var TABS = {
    PLAYLIST: 'PLAYLIST',
    HOME: 'HOME',
    GENRES: 'GENRES',
    RADIO: 'RADIO',
    SETTINGS: 'SETTINGS',
    STATUS: 'STATUS',
    HELP: 'HELP'
};

var PLAYLIST_COMMANDS = P_CMDS = {
    CLEAR: 'clear',
    DOWN: 'down',
    INSERT: 'insertFiles',
    GET_PLAYLIST: 'getPlaylist',
    GAIN: 'setGain',
    NEXT: 'next',
    PLAY: {
        TRACKS: 'play',
        RANDOM: 'playRandom',
        ARTIST_RADIO: 'playArtistRadio',
        TOP_TRACKS: 'playTopTracks',
        GENRE_RADIO: 'playGenreRadio',
        GROUP_RADIO: 'playGroupRadio',
        RELATED_ARTISTS_SAMPLER: 'playRelatedArtistsSampler'
    },
    PREVIOUS: 'previous',
    REMOVE: 'remove',
    REMOVE_MANY: 'removeMany',
    SHUFFLE: 'shuffle',
    START: 'start',
    SORT: {
        BY_TRACK: 'sortByTrack',
        BY_ALBUM: 'sortByAlbum',
        BY_ARTIST: 'sortByArtist'
    },
    STOP: 'stop',
    SKIP: 'skip',
    UNDO: 'undo',
    UP: 'up',
    TOGGLE_REPEAT: 'toggleRepeat'
};

var PLAYLIST_MODES = P_MODES = {
    PLAY: 'P',
    ENQUEUE: 'E',
    ADD: 'A',
    INSERT: 'I'
};