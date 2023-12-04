function do_it() {
  MODES_ARRAY=("patch" "minor" "major")
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  CHANGESET_FOLDER=$CURRENT_DIR/../changesets
  BUMP=-1


  echo "Preparing to version package: "
  for file in "$CHANGESET_FOLDER/*.txt"; do
    while read mode timestamp message; do
      for i in "${!MODES_ARRAY[@]}"; do
        [[ "${MODES_ARRAY[$i]}" = "$mode" ]] && break
      done
      
      if [ $i > $BUMP ]; then
          BUMP=$i
      fi
    done < $file
  done

  if [ $BUMP == 1 ]; then
    echo "No changesets found. Aborting version"
    exit 0
  fi

  echo mode selected: "${MODES_ARRAY[$BUMP]}"



}

do_it "$@"