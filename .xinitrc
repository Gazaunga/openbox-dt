#exec dbus-launch openbox-session
exec dbus-launch --exit-with-session emacs
ruby bin/rtile.rb &

# Cleanup unnecessary files
#rm -rf "$HOME/.cache/"
#rm -rf "$HOME/.thumbnails"
#rm -rf "$HOME/.local/share/Trash"

# FIX THIS
mv ~/.emacs.d/layers/lang ~/.emacs.d/layers/+lang
