#!/bin/bash

while true; do
  if hash inotifywait 2> /dev/null; then
    file=$(inotifywait -e modify . | grep "MODIFY.*elm" | sed "s/^.*MODIFY\s//")
  elif hash fswatch 2> /dev/null; then
    file=$(fswatch -1 *.elm | sed "s/^.*\/\(.*\)$/\1/")
  else
    echo "Can't find either inotifywait (Linux) or fswatch (macos), please install one of them and run the command again"
    break;
  fi

  echo "building file"
  case $file in
    "Main.elm")
      output="elm.js"
      ;;
    "Subscriber.elm")
      output="elm-subscriber.js"
      ;;
    *)
      echo 'nothing to do'
      continue
      ;;
  esac
  echo "file: $file, output: $output"

  elm-make $file --output $output
done
