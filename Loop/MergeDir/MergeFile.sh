#!/bin/bash

### 設定 ################################################################################
BaseDir="/path/to/search"       ### 検索元ディレクトリ
DestDir="/path/to/merged"      ### コピー先ディレクトリ
###
#
# $BaseDir/$PrefixBaseDir***$SuffixBaseDir/$PrefixBaseFile***$SuffixBaseFile
# -> $DestDir/$PrefixBaseFile***$SuffixBaseFile
#
###
PrefixBaseDir="A"
SuffixBaseDir="B"
PrefixBaseFile="C"
SuffixBaseFile="D"
if_zero_padding=( 
false  ### ゼロ埋めをするか
true  
true  
)
cyc_digit=(
3  ### $PrefixBaseDir***$SuffixBaseDir の *** の桁数
3  ### $PrefixBaseFile***$SuffixBaseFile の *** の桁数
4  ### $PrefixBaseFile***$SuffixBaseFile の *** の桁数
)
if_test=true  ### true のときはコピーなどを実施しない。コピー元とコピー先を確認する。
#########################################################################################

### 初期化
if [ "$if_test" != "true" ]; then
  mkdir -p "$DestDir"
fi
index=0

### 正規表現用の0埋めパターンを構築
SrcPattern=()
for i in "${cyc_digit[@]}"; do
  if [ "${if_zero_padding[$i]}" == "true" ]; then
    SrcPattern+=("$(printf "[0-9]{%d}" "${cyc_digit[$i]}")")  ### 0埋めを有効にする
  else
    SrcPattern+=("([0-9]+)")
    ###
    #
    # 「1文字以上の数字（0~9の連続）」にマッチする正規表現
    # * 0-9 --- 0~9 のどれか1文字
    # * +   --- 直前のものが1回以上繰り返される
    #
    ###
  fi
done

### $PrefixBaseDir***$SuffixBaseDir ディレクトリを探す
### findコマンドの結果を変数に保存し、直接ループで処理する
Dirs=$(find "$BaseDir" -maxdepth 1 -type d -regextype posix-extended -regex ".*/${PrefixBaseDir}${SrcPattern[0]}${SuffixBaseDir}")

for dir in $Dirs; do
  ### $PrefixBaseFile***$SuffixBaseFile ファイルを探す
  files=$(find "$dir" -maxdepth 1 -type f -regextype posix-extended -regex ".*/${PrefixBaseFile}${SrcPattern[1]}${SuffixBaseFile}")

  for file in $files; do
    if [[ -f "$file" ]]; then
      ### コピー先ファイル名を連番で生成
      newname="${PrefixBaseFile}$(printf "%0${cyc_digit[2]}d" "$index")${SuffixBaseFile}"
      if [ "$if_test" != "true" ]; then
        cp "$file" "${DestDir}/${newname}"
      fi
      echo "Copied: $file -> ${DestDir}/${newname}"
      index=$((index + 1))
    fi
  done
done

