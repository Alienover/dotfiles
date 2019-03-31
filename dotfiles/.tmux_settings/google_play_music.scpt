on executeJavaScript(activeTab, code)
  tell application "Google Chrome"
    return execute activeTab javascript code
  end tell
end executeJavaScript
on activeTab()
  set targetTab to null 
  tell application "Google Chrome"
    repeat with theWindow in every window
      repeat with theTab in every tab of theWindow
        if theTab's title ends with "- Google Play Music" then
          set targetTab to theTab
          exit repeat
        end if
      end repeat
    end repeat
  end tell

  return targetTab
end activeTab

on getCurrentSong()
  set targetTab to activeTab() of me

  if targetTab is not null then
    set songCode to "document.querySelector('#currently-playing-title').innerHTML"
    set song to executeJavaScript(targetTab, songCode) of me
    set artistCode to "document.querySelector('.currently-playing-details #player-artist').innerText"
    set artist to executeJavaScript(targetTab, artistCode) of me 
    try
      set currentSong to "♫  " & song & " - " & artist
      if currentSong does not contain "missing value" then
        return "♫  " & song & " - " & artist
      end if
    on error err
    end try
  end if
end getCurrentSong

if application "Google Chrome" is running then
  getCurrentSong()
end if
