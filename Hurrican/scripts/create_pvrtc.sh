#!/bin/bash

# This script creates PVRTC textures from all of the PNG's.
# It will upscale to POT if needed and convert the image to 32 bit PNG.
# It also creates the list of filename's with scaling in scalefactors.txt
# The resulting TC2 or TC4 files should be copied to data/textures/pvr
# The scalefactors.txt should be copied to data/textures/pvr

powerof2 () {
  # Get the original size of the image
  W=`identify ${f} | cut -f 3 -d " " | sed s/x.*//`
  H=`identify ${f} | cut -f 3 -d " " | sed s/.*x//`

  # Determine the next power of 2 greater the original image size
  P2W=`convert ${f} -format "%[fx:2^(ceil(log(w)/log(2)))]" info:`
  P2H=`convert ${f} -format "%[fx:2^(ceil(log(h)/log(2)))]" info:`
  if test $P2W -lt 32; then
    P2W=32
  fi
  if test $P2H -lt 32; then
    P2H=32
  fi

  # Calculate the ratio size increase
  FACTOR_W=$(echo "scale=3; $W/$P2W" | bc -l )
  FACTOR_H=$(echo "scale=3; $H/$P2H" | bc -l )

  # Remove the file extentsion
  FILENAME=${f%.*}
 
  # Display and write the results to file
  echo Width  ${FILENAME} ${FACTOR_W} ${W} ${P2W}
  echo Height ${FILENAME} ${FACTOR_H} ${H} ${P2W}
  echo ${FILENAME} ${FACTOR_W} ${FACTOR_H} >> ${TYPE2}/scalefactors.txt
  echo ${FILENAME} ${FACTOR_W} ${FACTOR_H} >> ${TYPE4}/scalefactors.txt
} 

export DATA="data/textures"
export TEX="tc"
export TYPE2=${TEX}"/pvrtc2"
export TYPE4=${TEX}"/pvrtc4"
export PNG32=${TEX}"/png32"

cd ../${DATA}
rm -rf ${TYPE2}
rm -rf ${TYPE4}
rm -rf ${PNG32}
mkdir ${TEX}
mkdir ${TYPE2}
mkdir ${TYPE4}
mkdir ${PNG32}

for f in *.png
do
  echo "Processing $f file..."
 
  powerof2
  
  convert ${f} -alpha on -extent ${P2W}x${P2H} PNG32:${PNG32}/${f}  

  ${PVRTEXTOOL}/PVRTexTool -fPVRTC2 -i${PNG32}/${f} -o ${TYPE2}/${f}.pvr
  ${PVRTEXTOOL}/PVRTexTool -fPVRTC4 -i${PNG32}/${f} -o ${TYPE4}/${f}.pvr
done
