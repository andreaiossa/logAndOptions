function do_it() {
  echo "Select the changeset for this commit"
  
  select opt in patch minor major cancel; do

  case $opt in
    patch)
      echo "Patch option selected: "
      read -p "Insert commit: " com

      git add -A
      git commit -am "$com"
      break
      ;;
    minor)
      echo "Minor option selected: "
      read -p "Insert commit: " com

      git add -A
      git commit -am "$com"
      break
      ;;
    major)
      echo "Major option selected"
      read -p "Are you sure, please confirm yout option [Y|n]" res

      if [ "$res" == "Y" ] || [ "$res" == "y" ]; then
        read -p "Insert commit: " com
        git add -A
        git commit -am "$com"
      fi
      break
      ;;
    cancel)
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