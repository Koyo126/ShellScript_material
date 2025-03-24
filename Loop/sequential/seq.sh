#!/bin/bash

NDir=16
DirDigit=4

### 例1
for ((iidir=0; idir<NDir; idir++)); do
  #dir=./$(printf '%03d' $idir)  ### 3 桁で 0 埋め
  dir=./$(printf "%0${DirDigit}d" $idir)
  echo $dir
done

### 例2
for idir in $(seq 0 $((NDir - 1))); do
  dir=./$(printf "%0${DirDigit}d" $idir)
  echo $dir
done
