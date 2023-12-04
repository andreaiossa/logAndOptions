function do_it() {
  MODES_ARRAY=("patch" "minor" "major")
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  CHANGESET_FOLDER=$CURRENT_DIR/../changesets
  META_FILE=$CHANGESET_FOLDER/meta.yaml
  BUMP=-1


  echo "Preparing to version package: "
  for file in $CHANGESET_FOLDER/*.txt; do
    while read mode timestamp message; do
      for i in "${!MODES_ARRAY[@]}"; do
        [[ "${MODES_ARRAY[$i]}" = "$mode" ]] && break
      done
      
      if [ $i -gt $BUMP ]; then
          BUMP=$i
      fi
    done < $file
  done

  if [ $BUMP -lt 0 ]; then
    echo "No changesets found. Aborting version"
    exit 0
  fi

  local MODE
  local NEW_VERSION
  local OLD_VALUE
  local NEW_VALUE

  MODE="${MODES_ARRAY[$BUMP]}"
  echo mode selected: $MODE
  
  OLD_PATCH=$(yq .$MODE $META_FILE)
  NEW_VALUE=$(( $OLD_VALUE + 1 ))
  yq -i ".$MODE = $NEW_VALUE" $META_FILE

  NEW_VERSION=$(yq .major $META_FILE).$(yq .minor $META_FILE).$(yq .patch $META_FILE)
  yq -i ".version = \"$NEW_VERSION\"" $META_FILE

  echo "Version to be bumped: $NEW_VERSION. Preparing to make new tag"
  git tag -a v$NEW_VERSION -m "MAKING VERSION"

  echo "Removing changesets"
  rm -rf $CHANGESET_FOLDER/*.txt
}

do_it "$@"