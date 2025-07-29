#!/bin/sh
FCONV="*.webp"
FTYPE=$(Xdialog --title 'Convert image to WEBP' --stdout --no-tags --menu 'File type' 30 40 40 '*.png' 'png' '*.jpg' 'jpg' '*.jpeg' 'jpeg' '*.avif' 'avif')
if [ -z "$FTYPE" ] ; then
  exit 1
fi
FREDUCE=$(Xdialog --title 'Resolution' --stdout --no-tags --menu 'Adjust resolution' 30 40 40 '0%' 'none' '40%' 'Reduce 60%' '50%' 'Reduce 50%' '60%' 'Reduce 40%' '70%' 'Reduce 30%' '80%' 'Reduce 20%' '90%' 'Reduce 10%')
if [ -z "$FREDUCE" ] ; then
  exit 1
fi
Xdialog --title 'Backup'  --stdout --default-no --yesno "Create backup?" 300x80
FBACKUP=$?
Xdialog  --title 'Confirmation' --yesno "Execute conversion? \n\n Convert $FTYPE to Webp   -  Resolution: $FREDUCE" 300x140
FEXECUTE=$?
# Main
if [ $FEXECUTE -eq 0 ]; then
 # Xdialog --stdout --msgbox "Type = [$FTYPE];   Reduce = [$FREDUCE];  Execute = [$FEXECUTE];  Backup = [$FBACKUP]" 400x140
  FBACKUP_FOLDER=Backup_$(date +%Y%m%d_%H%M%S)
  FOLDER=`pwd | rev | cut -d'/' -f1 | rev`
  BEFORE=`du -cm $FTYPE | tail -n 1 | cut -f1`
  mkdir "$FBACKUP_FOLDER"
  cd "$FBACKUP_FOLDER"
  mv ../$FTYPE .
  magick mogrify -format webp $FTYPE
  if [ "$FREDUCE" != "0%" ]; then
    find ./ -name "$FCONV" -print0 | sort -z | xargs -0 -I @ sh -c 'convert @ -resize '$FREDUCE' @'
  fi
  mv *.webp ..
  cd ..
  if [ $FBACKUP -ne 0 ] ; then
    rm -rf "$FBACKUP_FOLDER"
  fi
  AFTER=`du -cm $FCONV | tail -n 1 | cut -f1`
  Xdialog --msgbox "Folder: $FOLDER  \n\n Convert $FTYPE to $FCONV (option reduce $FREDUCE) complete \n\n Total size before ($FTYPE): $BEFORE MB \n Total size after ($FCONV): $AFTER MB" 15 180
else
  Xdialog--title 'Cancel' --stdout --msgbox "Execute aborted." 300x140
fi
