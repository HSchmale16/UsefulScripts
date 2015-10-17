# Henry J Schmale
# October 11, 2015
# 
# An extra bashrc file that contains various useful aliases and functions
# Add to your enviroment by adding the following lines to your regular
# .bashrc. It also does some other terminal magic like setting up my
# enviroment the way that I like it to be setup.
# I wrote this because I wanted to be able to share configuration
# settings between all of my machines, and this way allows me to do just
# that with the magic of source.
#
#   if [ -f PATH_TO_THIS_FILE ]; then
#       source PATH_TO_THIS_FILE
#   fi
#
# Where PATH_TO_THIS_FILE is the path to this file

# Custom Prompt
PS1=\
'\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\]\[\e[1;37m\]'

# Set my editor
export EDITOR=vim
export VISUAL=vim

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
