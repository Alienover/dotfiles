on output(input, prefix)
    if input is not "" then
        set strLength to the length of input

        if strLength is greater than 50 then
            set input to text from beginning to 50th character of input
        end if

        return prefix & "  " & input
    end if 

    return ""
end output

on executeJavaScript(activeTab, code)
  tell application "Google Chrome"
    return execute activeTab javascript code
  end tell
end executeJavaScript

on getSpotifySong(activeTab)
    set titleJsCode to "document.querySelector('title').innerHTML"
    
    if activeTab is not null then
        set current to executeJavaScript(activeTab, titleJsCode) of me
        return current
    end if

    return ""
end getSpotifySong

on getYoutubeMusicSong(activeTab)
	set songJsCode to "document.querySelector('.ytmusic-player-bar .subtitle .complex-string').title"

	if activeTab is not null then
		try
			set song to executeJavaScript(activeTab, songJsCode) of me
			return song
		on error err
			return ""
		end try
	end if

	return ""
end getYoutubeMusicSong

on getGoogleChromeSong()
    set prefix to ""
    set current to ""

    tell application "Google Chrome"
        repeat with theWindow in every window
            repeat with theTab in every tab of theWindow
                if theTab's URL contains "spotify.com" and theTab's title does not contain "Spotify" then
                    (* Spotify *)

                    set prefix to ""
                    set current to getSpotifySong(theTab) of me
                    exit repeat
                else if theTab's URL contains "music.youtube.com" and theTab's title ends with "- Youtube Music" then
                    (* Youtube Music *)

                    set prefix to ""
                    set current to getYoutubeMusicSong(theTab) of me
                    exit repeat
                end if
            end repeat

            if current is not "" then
                    exit repeat
            end if
        end repeat
    end tell
    
    return {current, prefix}
end getCurrentSong

on getAppleMusicSong()
    set prefix to ""
    set current to ""

    tell application "Music"
        if player state is playing then
            set currName to name of current track
            set curArtist to artist of current track

            set current to currName & " - " & curArtist
        end if 
    end tell

    return {current, prefix}
end getAppleMusicSong

on getSpotifyAppSong()
    set prefix to ""
    set current to ""

    tell application "Spotify"
	if player state is playing then
	    set currName to name of current track
	    set currArtist to artist of current track

	    set current to currName & " - " & currArtist
	end if
    end tell

    return {current, prefix}
end getSpotifyAppSong

set current to ""
set prefix to ""

if application "Spotify" is running then
    set {current, prefix} to getSpotifyAppSong() of me
end if

if current is "" and application "Music" is running then
    set {current, prefix} to getAppleMusicSong() of me
end if

if current is "" and application "Google Chrome" is running then
    set {current, prefix} to getGoogleChromeSong() of me
end if

output(current, prefix)
