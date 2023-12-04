function do_it() {
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  CHANGESET_FOLDER=$CURRENT_DIR/../changesets
  BUMP=no-bumb


  echo "Preparing to version package"
  for file in $CHANGESET_FOLDER/*.txt
  do
      while read mode timestamp message; do
          echo "$mode - $timestamp - $message"
      done < file
  done
}

do_it "$@"