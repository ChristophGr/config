#!/bin/bash  
# Dieses Skript convertiert alle ogg-Dateien im aktuellen Verzeichnis in mp4 Audio (aac)
# um. Damit sie von einem iPod abgespielt werden können

ME=`basename ${0}`

OGG2WAV="/usr/bin/mplayer"
WAV2MP3="/usr/bin/lame"

EXT="ogg"

do_error() {
  echo "$*"
  exit 1
  } 

create_wav() {  # use mplayer(1) to convert from ogg to WAV

 echo -n "Creating intermediate WAV file"
  ${OGG2WAV} -ao pcm "${1}" -ao pcm:file="${2}"
 echo ".  OK"
  } 

create_aac() {  # use faac to convert from wav to aac
  echo -n "Creating output AAC file"´
  ${WAV2MP3} "${1}" "${2}"
  echo ".  OK"
  }

do_cleanup() {  # Delete intermediate and (optionally) original file(s)
  echo -n "Deleting intermediate file"
  rm -f "${2}"
  echo ".  OK"
  } 

test -f $MPLAYER || do_error "$MPLAYER not found. Use \"-m\" switch."


  for IFILE in *.${EXT}
  do
    if [ "${IFILE}" == "*.${EXT}" ]
    then
      do_error "No files with extension ${EXT} in this directory."
    fi 

    OUT=`echo "${IFILE}" | sed -e "s/\.${EXT}//g"`

    create_wav "${IFILE}"   "${OUT}.wav"
    create_aac "${OUT}.wav" "${OUT}.mp3"
    do_cleanup "${IFILE}"   "${OUT}.wav"

  done


exit 0