#!/bin/bash

export DATA="data/textures"
export TEX="tc"
export TYPE=${TEX}"/etc1"

cd ../${DATA}
rm -rf ${TYPE}
mkdir ${TEX}
mkdir ${TYPE}

for f in *.png
do
  echo "Processing $f file..."
  
  ${MALI_TEX}/bin/etcpack ${f} ${TYPE} -s fast -c etc1 -ext PNG -as
done

# ETCPACK v4.0.1 for ETC and ETC2
# Compresses and decompresses images using Ericsson Texture Compression (ETC)                version 1.0 and 2.0.
# 
# Usage:
#     etcpack <input_filename> <output_directory> [Options]
# Options:
#       -s {fast|slow}                     Compression speed. Slow = exhaustive 
#                                          search for optimal quality
#                                          (default: fast).
#       -e {perceptual|nonperceptual}      Error metric: Perceptual (nicest) or 
#                                          nonperceptual (highest PSNR)
#                                          (default: perceptual).
#       -c {etc1|etc2}                     Codec: etc1 (most compatible) or 
#                                          etc2 (highest quality)
#                                          (default: etc2).
#       -f {R|R_signed|RG|RG_signed|       Compressed format: one, two, three
#           RGB|RGBA1|RGBA8 or RGBA}       or four channels, and 1 or 8 bits
#                                          for alpha (1 equals punchthrough)
#                                          (default: RGB).
#       -mipmaps                           Generate mipmaps.   
#       -ext {PPM|PGM|JPG|JPEG|PNG|GIF|    Uncompressed formats
#             BMP|TIF|TIFF|PSD|TGA|RAW|    (default PPM).
#             PCT|SGI|XPM}
#       -ktx                               Output ktx files, not pkm files.
#       -v                                 Verbose mode. Prints additional
#                                          information during execution.
#       -progress                          Prints compression progress.
#       -version                           Prints version number.
#                                          
# Options to be used only in conjunction with etc codec (-c etc):
#       -aa                                Use alpha channel and create a
#                                          texture atlas.
#       -as                                Use alpha channel and create a
#                                          separate image.
#       -ar                                Use alpha channel and create a
#                                          raw image.
#                                          
# Examples: 
#   etcpack img.ppm myImages               Compresses img.ppm to myImages\img.pkm
#                                          in ETC2 RGB format.
#   etcpack img.ppm myImages -ktx          Compresses img.ppm to myImages\img.ktx
#                                          in ETC2 RGB format.
#   etcpack img.pkm myImages               Decompresses img.pkm to
#                                          myImages\img.ppm.
#   etcpack img.ppm myImages -s slow       Compress img.ppm to myImages\img.pkm
#                                          using the slow mode.
#   etcpack img.tga MyImages -f RGBA       Compresses img.tga to MyImages\img.pkm
#                                          using etc2 + alpha.
#   etcpack img.ppm MyImages  -f RG        Compresses red and green channels of
#                                          img.ppm to MyImages\img.pkm.
#   etcpack img.pkm MyImages -ext JPG      Decompresses img.pkm to
#                                          MyImages\img.jpg.
#   etcpack orig.ppm images\copy.ppm -p    Calculate PSNR between orig.ppm and
#                                          images\copy.ppm.
#                                          Instead of output directory a full
#                                          file path is given as a second
#                                          parameter.
