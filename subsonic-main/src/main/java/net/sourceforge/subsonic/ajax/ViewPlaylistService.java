/*
 This file is part of Subsonic.

 Subsonic is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Subsonic is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Subsonic.  If not, see <http://www.gnu.org/licenses/>.

 Copyright 2009 (C) Sindre Mehus
 */
package net.sourceforge.subsonic.ajax;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.domain.MediaFile;
import net.sourceforge.subsonic.domain.MetaData;
import net.sourceforge.subsonic.domain.Playlist;
import net.sourceforge.subsonic.service.MediaFileService;
import net.sourceforge.subsonic.service.PlaylistService;
import net.sourceforge.subsonic.util.StringUtil;

import org.directwebremoting.WebContextFactory;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.github.hakko.musiccabinet.service.PlaylistGeneratorService;

/**
 * Provides AJAX-enabled services for manipulating the playlist of a player.
 * This class is used by the DWR framework (http://getahead.ltd.uk/dwr/).
 *
 * @author Sindre Mehus
 */
public class ViewPlaylistService {

    private static final Logger LOG = Logger.getLogger(ViewPlaylistService.class);

    private MediaFileService mediaFileService;
	private PlaylistService playlistService;

    /**
     * Returns the playlist for the player of the current user.
     *
     * @return The playlist.
     */
    public PlaylistInfo getPlaylistFromName(String name) throws Exception {
        HttpServletRequest request = WebContextFactory.get().getHttpServletRequest();
        Playlist playlist = new Playlist();
        playlistService.loadPlaylist(playlist, name);
        return convert(request, playlist);
    }

    private PlaylistInfo convert(HttpServletRequest request, Playlist playlist) throws Exception {
        Locale locale = RequestContextUtils.getLocale(request);

        List<PlaylistInfo.Entry> entries = new ArrayList<PlaylistInfo.Entry>();
        for (MediaFile file : playlist.getFiles()) {
            MetaData metaData = file.getMetaData();

            entries.add(new PlaylistInfo.Entry(metaData.getTrackNumber(), metaData.getTitle(), file.getId(), metaData.getArtist(),
            		metaData.getArtistId(), metaData.getAlbum(), metaData.getAlbumId(), metaData.getComposer(),
            		metaData.getGenre(), metaData.getYear(), formatBitRate(metaData), metaData.getDuration(),
            		metaData.getDurationAsString(), metaData.getFormat(), formatContentType(metaData.getFormat()),
            		formatFileSize(metaData.getFileSize(), locale), file.getPath(), null));
        }
        return new PlaylistInfo(entries, playlist.getIndex(), false, false, false, 0.0f);
    }

    private String formatFileSize(Long fileSize, Locale locale) {
        if (fileSize == null) {
            return null;
        }
        return StringUtil.formatBytes(fileSize, locale);
    }

    private String formatContentType(String format) {
        return StringUtil.getMimeType(format);
    }

    private String formatBitRate(MetaData metaData) {
        if (metaData.getBitRate() == null) {
            return null;
        }
        if (Boolean.TRUE.equals(metaData.getVariableBitRate())) {
            return metaData.getBitRate() + " Kbps vbr";
        }
        return metaData.getBitRate() + " Kbps";
    }

    public void setMediaFileService(MediaFileService mediaFileService) {
        this.mediaFileService = mediaFileService;
    }

	public void setPlaylistService(PlaylistService playlistService) {
		this.playlistService = playlistService;
	}

}