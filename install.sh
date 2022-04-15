# Author arthurkiller
# email arthur-lee@qq.com
# data 2017-1-4
# this shell is used for initialize the tmux-config

#!/bin/bash

trap exit ERR

ln -s $HOME/.tmux/.tmux.conf $HOME/.tmux.conf

cd ~/.tmux/vendor/tmux-mem-cpu-load && cmake . && make && sudo make install

tmux source-file ~/.tmux.conf
