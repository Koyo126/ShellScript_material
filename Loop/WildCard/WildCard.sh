#!/bin/bash

for dir in ./test*; do
  ### 除外対象のディレクトリ名と一致したらスキップ
  if [ $dir == "./testskip" ]; then
    echo "$dir" : skip
    continue
  fi

  echo "$dir"
done
