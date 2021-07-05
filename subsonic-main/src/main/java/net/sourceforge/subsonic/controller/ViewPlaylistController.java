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
package net.sourceforge.subsonic.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.ParameterizableViewController;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.domain.User;
import net.sourceforge.subsonic.domain.UserSettings;
import net.sourceforge.subsonic.domain.Playlist;
import net.sourceforge.subsonic.service.SecurityService;
import net.sourceforge.subsonic.service.SettingsService;
import net.sourceforge.subsonic.service.PlaylistService;
import net.sourceforge.subsonic.util.StringUtil;

/**
 * Controller for the playlist frame.
 *
 * @author Sindre Mehus
 */
public class ViewPlaylistController extends ParameterizableViewController {

    private SecurityService securityService;
    private SettingsService settingsService;
    private PlaylistService playlistService;

    private Logger LOG = Logger.getLogger(ViewPlaylistController.class);
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = securityService.getCurrentUser(request);
        UserSettings userSettings = settingsService.getUserSettings(user.getUsername());

        String name = request.getParameter("name");

        Map<String, Object> map = new HashMap<String, Object>();

        if (name != null) {
            Playlist playlist = new Playlist();
            playlistService.loadPlaylist(playlist, name);  
            map.put("playlistName", name);  
            map.put("trimmedName", name.substring(0, name.lastIndexOf('.')));   
        }

        map.put("user", user);
        map.put("visibility", userSettings.getPlaylistVisibility());

        ModelAndView result = super.handleRequestInternal(request, response);
        result.addObject("model", map);
        return result;
    }

    public void setSecurityService(SecurityService securityService) {
        this.securityService = securityService;
    }

    public void setSettingsService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    public void setPlaylistService(PlaylistService playlistService) {
        this.playlistService = playlistService;
    }
}