#! /bin/bash
## Start a jekyll server in a tmux window.  
## For starting jekyll and, if desired, starting a shell in the same window.
## thank you to : Jacob Degeling for this stackoverflow answer : https://unix.stackexchange.com/a/354769
tmux new-session -d -s mySession -n myWindow
tmux send-keys -t mySession:myWindow "bundle exec jekyll serve --host 0.0.0.0" Enter
tmux splitw -v -p 50
tmux attach -t mySession:myWindow

