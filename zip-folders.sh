#!/bin/bash
mkdir ../zip
for i in */; do zip -r "../zip/${i%/}.zip" "$i" &; done
