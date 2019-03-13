function Capture-Screen($outPath) {
    &"C:\Program Files\VideoLAN\VLC\vlc.exe" -I dummy screen:// --one-instance :screen-fps=16 :live-caching=300 :screen-left=0 :screen-width=1920 --sout $('#transcode{vcodec=h264,vb072}:standard{access=file,mux=mp4,dst="' + $outPath + '"')
}

function End-ScreenCapture() {
    &"C:\Program Files\VideoLAN\VLC\vlc.exe" --one-instance vlc://quit
}