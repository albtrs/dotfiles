#!/bin/zsh

local -A opthash
zparseopts -D -A opthash -- p d:

# default init
work_dir=$HOME/doc/dialy
open_file_date=$(date "+%Y/%m/%d.md")

# options
if [[ -n "${opthash[(i)-p]}" ]]; then
  work_dir=$HOME/Dropbox/plane/dialy
fi

if [[ -n $@ ]]; then
  y=$(echo $@ | cut -b 1-2)
  m=$(echo $@ | cut -b 3-4)
  d=$(echo $@ | cut -b 5-6)
  open_file_date=20$y/$m/$d.md
fi

# create
open_dir_date=$(echo $open_file_date | cut -b -7)
mkdir -p $work_dir/$open_dir_date
vim $work_dir/$open_file_date