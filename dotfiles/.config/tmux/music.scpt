on output(input)
    set prefix to "♫"

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

on getGoogleMusicSong(activeTab)
    set songJsCode to "document.querySelector('#currently-playing-title').innerHTML"
    set artistJsCode to "document.querySelector('.currently-playing-details #player-artist').innerText"

    if activeTab is not null then
        set song to executeJavaScript(activeTab, songJsCode) of me
        set artist to executeJavaScript(activeTab, artistJsCode) of me 
        try
        if currentSong does not contain "missing value" then
            return song & " - " & artist
        end if
        on error err
        end try
    end if
end getGoogleMusicSong

on getGoogleChromeSong()
    set current to ""

    tell application "Google Chrome"
        repeat with theWindow in every window
            repeat with theTab in every tab of theWindow
                if theTab's URL contains "spotify.com" and theTab's title does not contains "Spotify" then
		    (* Spotify *)

                    set current to getSpotifySong(theTab) of me
                    exit repeat
                else if theTab's title ends with "- Google Play Music" then
		    (* Goole Play Music *)

                    set current to getGoogleMusicSong(theTab) of me
                    exit 
                end 
            end repeat

            if current is not null then
                exit repeat
            end if
        end repeat
    end tell
    
    return current
end getCurrentSong

on getAppleMusicSong()
    set current to ""

    tell application "Music"
        if player state is playing then
            set currName to name of current track
            set curArtist to artist of current track

            set current to currName & " - " & curArtist
        end if 
    end tell

    return current
end getAppleMusicSong

set current to ""

if application "Music" is running then
    set current to getAppleMusicSong() of me
end if

if current is "" and application "Google Chrome" is running then
    set current to getGoogleChromeSong() of me
end if

output(current)
