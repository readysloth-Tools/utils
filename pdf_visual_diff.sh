#!/bin/sh -x

FIRST="$(readlink -f "$1")"
SECOND="$(readlink -f "$2")"

BUILD_DIR=$(mktemp -d)
CURRENT_DIR="$PWD"

cd "$BUILD_DIR"

  convert -define png:color-type=6 -density 150 "$FIRST" -quality 90 first.png &
  convert -define png:color-type=6 -density 150 "$SECOND" -quality 90 second.png &

  wait $(jobs -p)

  for i in {0..102}
  do
    convert -define png:color-type=6 -gravity Center first-$i.png second-$i.png -compose subtract -composite result-$i.png &
  done

  wait $(jobs -p)

  convert result-{0..102}.png "$CURRENT_DIR"/diff_result.pdf
cd $CURRENT_DIR
