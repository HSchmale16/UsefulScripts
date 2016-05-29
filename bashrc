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
'\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\]\[\e[1;37m\]'

# Set my editor, which is vim.
export EDITOR=vim
export VISUAL=vim

# Set up piping to my xclipboard
alias p2clip='xclip -selection c'

# pandoc bash completion, only if pandoc is installed
if ! hash pandoc 2>&1 /dev/null
then
    eval "$(pandoc --bash-completion)"
fi

function copy-ssh-pub-key() {
    cat ~/.ssh/id_rsa.pub | p2clip
}

# Parallel Make and other improvements to make
export NUMCPUS=$(grep -c 'cpu cores' /proc/cpuinfo)
alias make='time make'
alias pmake='time make -j$NUMCPUS'

case "$(uname)" in
    # Linux only things
    Linux)
        # say command for linux while maintaining mac compatibility
        function say {
            echo "$@" | espeak -s 120 2> /dev/null
        }
        ;;
    # Mac Only things
    Darwin)
        ;;
esac

# Clear Screen in THE WINDOWS WAY!
# This is the only good thing about windows
alias cls=clear

# Awesome Commit Message
# sometimes I just fell like getting the commit out of the way and not
# leaving a good one. This is mostly for personal projects.
alias git-randcommit='git commit -am "$(curl -s http://whatthecommit.com/index.txt)"'

# Removes cmake makefiles for a project.
function cmake-clean() {
    rm CMakeCache.txt
    rm -rf CMakeFiles
    rm -rf CMakeScripts
    rm Makefile
    rm cmake_install.cmake
    rm install_manifest.txt
}


