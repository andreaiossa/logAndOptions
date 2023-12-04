function commit_and_save() {
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  RANDOM_FILE_NAME=$(uuidgen)
  FILE_TO_CREATE=$CURRENT_DIR/../changesets/$RANDOM_FILE_NAME.txt
  TIMESTAMP=$(date +%s)
  read -p "Insert commit: " com

  git add -A
  git commit -am "$com"
  touch $FILE_TO_CREATE
  echo "$1 $TIMESTAMP "$com" " > $FILE_TO_CREATE
  break
}

function do_it() {
  echo "Select the changeset for this commit"
  
  select opt in patch minor major; do
  case $opt in
    patch)
      echo "Patch option selected: "
      commit_and_save "patch"
      ;;
    minor)
      echo "Minor option selected: "
      commit_and_save "minor"
      break
      ;;
    major)
      echo "Major option selected"
      read -p "Are you sure, please confirm your option [Y|n]" res

      if [ "$res" == "Y" ] || [ "$res" == "y" ]; then
        commit_and_save "major"
      fi
      break
      ;;
    *) 
      echo "Invalid option $REPLY"
      break
      ;;
  esac
done
}

do_it "$@"