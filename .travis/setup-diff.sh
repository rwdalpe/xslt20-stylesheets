#!/bin/bash
echo "Setting up diff tools..."

if [ "$DELTA_BASE" != "" ] && [ "$DELTA_NAME" != "" ] && [ "DELTA_PASS" != "" ]
then
    echo "Installing tools..."
    rm -rf delta
    mkdir delta
    cd delta
    curl -s -o filelist -u "$DELTA_NAME:$DELTA_PASS" -s "$DELTA_BASE/smalllist"
    for f in `cat filelist`; do
        curl -s -o $f -u "$DELTA_NAME:$DELTA_PASS" -s "$DELTA_BASE/$f"
    done
else if [ -d "$DELTA_LOCAL" ]
then
    echo "Installing local tools..."
    rm -rf delta
    mkdir delta
    cd delta
    for f in `cat $DELTA_LOCAL/smalllist`; do
        cp "$DELTA_LOCAL/$f" .
    done
fi
fi
