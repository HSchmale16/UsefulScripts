# Henry J Schmale
# October 11, 2015
# 
# An extra bashrc file that contains various useful aliases and functions
# Add to your enviroment by adding the following lines to your regular
# .bashrc. I wrote this because I wanted to be able to share configuration
# settings between all of my machines, and this way allows me to do just
# that with the magic of source.
#
#   if [ -f PATH_TO_THIS_FILE ]; then
#       source PATH_TO_THIS_FILE
#   fi
#
# Where PATH_TO_THIS_FILE is the path to this file

_myos="$(uname)"

# Parallel Make and other improvements to make
export NUMCPUS=$(grep -c 'cpu cores' /proc/cpuinfo)
alias make='time make'
alias pmake='time make -j$NUMCPUS'

# Word Count Stuff
# Calculate the word count of all the text documents in a directory and
# it's subdirs.
function recwc {
    local pipe='/tmp/recwcpipe'
    for f in $(find . -name '*.tex'; find . -name '*.md')
    do
        wc $f >> $pipe
    done
    awk '{words += $2; lines += $1; files += 1; print $1"\t"$2"\t"$4}
            END{print "Words: "words; print "Lines: "lines; 
            print "Files: "files}' $pipe
    rm -f $pipe
}
