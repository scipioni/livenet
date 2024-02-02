#!/bin/bash
. .env

# giorno 11/12/2023

# task release ---> 20231211.00.00
# task commit  ---> 20231211.00.01
# task commit  ---> 20231211.00.02
# task release ---> 20231211.01.00
# task commit  ---> 20231211.01.01

# giorno 12/12/2023

# task commit  ---> 20231211.01.02  Aggiornata release corrente
# task release ---> 20231212.00.00  Nuova con timestamp nuovo
# task commit  ---> 20231212.00.01

# Effettua tutti i controlli e rilascia il numero di relesease successivo
# Il container deve essere in esecuzione
# In caso di commit deve esistere l'archivio full di origine

do_increment() {
  NUMBER=$1
  digits=${#NUMBER}
  NUMBER=$( bc <<< "$NUMBER+1" )

  NUMBER=$(printf "%0${digits}d\n" "$NUMBER")
  echo $NUMBER
}

_w=$1

[[ -n $_w ]] || exit 1
[[ $_w =~ ^(commit|release)$ ]] || exit 1



state=$( ${_docker} inspect ${NODE} | jq ".[0] .State .Running")
if [ ! $state = true ]; then
  >&2 echo "container is not running"
  exit 1
fi

# RELEASE del server in esecuzione
VERSION=$( ${_compose} exec -T ${NODE} cat /etc/livenet/release | cut -d'=' -f2)
VERSION=$(docker inspect ${NODE} | jq -r ".[0] .Config .Image" | cut -d':' -f2)

RELEASE=$(echo $VERSION | cut -d'.' -f1 )
_today=$(date +%Y%m%d)

MINOR=$(echo $VERSION | cut -d'.' -f3 )
MAJOR=$(echo $VERSION | cut -d'.' -f2 )

case $_w in

  commit)
    if [ ! -f "./releases/$RELEASE.$MAJOR.00-full.tar.gz" ]; then
      >&2 echo "Release completa non presente ($RELEASE.$MAJOR.00-full.tar.gz)"
      exit 1
    fi
    MINOR=$(do_increment $MINOR)
    ;;

  release)
    if [ $_today != $RELEASE ]; then
      echo "$_today.00.00"
      exit 0
    fi
    MAJOR=$(do_increment $MAJOR)
    ;;

  *)
    exit 1
    ;;
esac


echo "$RELEASE.$MAJOR.$MINOR"

exit 0 