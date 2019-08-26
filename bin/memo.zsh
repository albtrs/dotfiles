#!/bin/zsh

local -A opthash
zparseopts -D -A opthash -- p

# -------------------------------------------
# init
# -------------------------------------------
work_dir=$HOME/doc/memo

if [[ -n "${opthash[(i)-p]}" ]]; then
  work_dir=$HOME/Dropbox/plane/memo
fi

mkdir -p $work_dir

# -------------------------------------------
# functions
# -------------------------------------------
function create_new {
  if [ -n "$1" ]; then
    title=$1
  else
    echo Title:
    read title
    title=$(echo "$title" | sed 's/ /-/g')
  fi

  if [ -n "$title" ]; then
    file=$(date "+%Y-%m-%d-$title.md")
    $EDITOR $work_dir/$file
  else
    echo 'empty filename.'
  fi
}

function edit {
  if [ -n "$1" ]; then
    query=$1
  fi

  file=$(ls $work_dir | fzf -q "$query")
  if [ -n "$file" ]; then
    $EDITOR $work_dir/$file
  fi
}

function list {
  ls -1 $work_dir
}

function grep {
  ag "$1" $work_dir
}

function remove {
  if [ -n "$1" ]; then
    query=$1
  fi

  file=$(ls $work_dir | fzf -q "$query")
  if [ -n "$file" ]; then
    echo $work_dir/$file
    echo "ok?(y/N): "
    if read -q; then
      rm $work_dir/$file
    else
      echo Cancelled.
    fi
  fi
}

function server {
  cd $work_dir
  markserv .
  cd -
}

# -------------------------------------------
# sub command case
# -------------------------------------------
subcmd=$1
if [ "$subcmd" = n ] || [ "$subcmd" = new ]; then
  create_new $2
elif [ "$subcmd" = e ] || [ "$subcmd" = edit ]; then
  edit $2
elif [ "$subcmd" = l ] || [ "$subcmd" = list ]; then
  list $2
elif [ "$subcmd" = g ] || [ "$subcmd" = grep ]; then
  grep $2
elif [ "$subcmd" = r ] || [ "$subcmd" = remove ]; then
  remove $2
elif [ "$subcmd" = s ] || [ "$subcmd" = server ]; then
  server $2
else
  echo 'command not found.'
fi