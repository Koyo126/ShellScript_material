#!/bin/bash

##########################################################
#
# $base_dir/$sub_dir/*** -> $dest_base/***
#
##########################################################

### 変数の設定 ###########################################
base_dir="./"  ### チェック元 -> base_dir/1/SE/***
dest_base="./merged"  ### コピー先
sub_dir="/SE"
sys_digit0=3  ### コピー元のディレクトリの桁数
sys_digit1=4  ### コピー先のディレクトリの桁数
if_test=true  ### true のときはコピーなどを実施しない。
##########################################################

if [ "$if_test" != "true" ]; then
  mkdir -p "$dest_base"
fi
counter=0  ### 作業用変数

for dir in $(ls -d "$base_dir"/*/ | sed 's:/$::' | xargs -n 1 basename | grep -E '^[0-9]+$' | sort -n); do
  ###
  #
  # * ls -d "$base_dir"/*/ -> $base_dir 以下のすべてのディレクトリをリスト
  # * sed 's:/$::' -> 末尾のスラッシュを取り除く
  # * xargs -n 1 basename -> ディレクトリ名を取得
  # * grep -E '^[0-9]+$' -> 数字だけで構成されたディレクトリ名のみ通す
  # * sort -n -> 昇順でソート
  #
  ###

  full_dir="$base_dir/$dir"  ### 1/, 2/
  se_dir="$full_dir/$sub_dir"  ### 1/SE/, 2/SE/, 
  if [ -d "$se_dir" ]; then
    for subdir in "$se_dir"/*/; do
      [ -d "$subdir" ] || continue  ### 念のためチェック
      name=$(basename "$subdir")
      if [[ "$name" =~ ^[0-9]{$sys_digit0}$ ]]; then
        new_name=$(printf "%0${sys_digit1}d" "$counter")
        if [ "$if_test" != "true" ]; then
          cp -r "$subdir" "$dest_base/$new_name"
        fi
        echo "Copied $subdir -> $dest_base/$new_name"
        ((counter++))
      fi
    done
  fi
done

