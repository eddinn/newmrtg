#!/bin/bash
PATH=/bin:/sbin:/usr/sbin:/usr/bin

CFGMAKER=$(command -v cfgmaker)
export CFGMAKER

INDEXMAKER=$(command -v indexmaker)
export INDEXMAKER

NICE=$(command -v nice)
export NICE

MRTG=$(command -v mrtg)
export MRTG

export WORKDIR="/path/to/mrtg"

if [ $# != 4 ]; then
  echo "Usage:"
  echo "newmrtg ip cfgname name snmpcommunity"
  exit 1
fi
echo "Adding $3 to MRTG"
"$CFGMAKER" --global "Options[_]: bits" --global WorkDir: "$WORKDIR" --ifdesc=alias "$4@$1" > "$WORKDIR"/"$2".cfg
"$INDEXMAKER" --title "$3" "$WORKDIR"/"$2".cfg --output "$WORKDIR"/"$2".html
"$NICE" "$MRTG" "$WORKDIR"/"$2".cfg 2>&1 | cat /dev/null
sleep 1
"$NICE" "$MRTG" "$WORKDIR"/"$2".cfg 2>&1 | cat /dev/null
echo -e "$3 successfully added to MRTG"
exit 0
