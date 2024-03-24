for var in "$@"
do
  case "$var" in 
    "ruby")
      echo "Installing Ruby"
      asdf plugin add ruby
      asdf install ruby latest
      asdf global ruby latest
      ;;
    "python")
      echo "Installing Python"
      asdf plugin add python
      asdf install python latest
      asdf global python latest
      ;;
    "nodejs")
      echo "Installing NodeJS"
      asdf plugin add nodejs
      asdf install nodejs latest
      asdf global nodejs latest
      npm install -g yarn
      ;;
    *) echo "usage ./asdf-plugins.sh 'ruby python nodejs'";;
  esac
done
