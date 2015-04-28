#!/usr/bin/perl
# Autoversion Script
# A script to make an autoversion header
#
# usage:
#   version.h: $(SRC)
#       @./autoversion.sh

rev=$(git rev-list HEAD --count)
myd=$(date +%m/%d/%Y)
vh=version.h

echo "#ifndef VERSION_H_INC" > $vh
echo "#define VERSION_H_INC" >> $vh
echo "const int REVSION       = $rev;" >> $vh
echo "const char BUILD_DATE[] = \"$myd\";" >> $vh
echo "#endif // VERSION_H_INC" >> $vh
