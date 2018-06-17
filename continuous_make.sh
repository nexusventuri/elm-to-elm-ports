#!/bin/bash

while true; do
  file=$(inotifywait -e modify . | grep "MODIFY.*elm" | sed "s/^.*MODIFY\s//")

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
