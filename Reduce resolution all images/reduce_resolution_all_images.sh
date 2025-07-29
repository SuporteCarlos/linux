#!/bin/sh
FTYPE=$(Xdialog --title 'Reduce resolution' --stdout --no-tags --menu 'File type' 30 40 40 '*.png' 'png' '*.jpg' 'jpg' '*.jpeg' 'jpeg' '*.webp' 'webp' '*.avif' 'avif')
if [ -z "$FTYPE" ] ; then
  exit 1
fi
FREDUCE=$(Xdialog --title 'New resolution' --stdout --no-tags --menu 'Adjust resolution' 30 40 40 '0%' 'none' '40%' 'Reduce 60%' '50%' 'Reduce 50%' '60%' 'Reduce 40%' '70%' 'Reduce 30%' '80%' 'Reduce 20%' '90%' 'Reduce 10%')
if [ -z "$FREDUCE" ]; then
  exit 1
fi
if $(Xdialog --title 'Confirmation' --yesno "Execute resolution adjust \n\n Resolution $FTYPE  -  $FREDUCE" 240x140) ; then
  FOLDER=`pwd | rev | cut -d'/' -f1 | rev`
  BEFORE=`du -cm $FTYPE | tail -n 1 | cut -f1`
  find ./ -name "$FTYPE" -print0 | sort -z | xargs -0 -I @ sh -c 'convert @ -resize '$FREDUCE' @'
  AFTER=`du -cm $FTYPE | tail -n 1 | cut -f1`
  Xdialog --title 'Result' --msgbox "Folder: $FOLDER  \n\n Adjust resolution $FREDUCE $FTYPE complete \n\n Total size before: $BEFORE MB \n Total size after: $AFTER MB" 15 180
fi
