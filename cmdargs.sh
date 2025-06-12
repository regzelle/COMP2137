#! /bin/bash

cat <<EOF

The command to run the script was "$0"

THe filename for the script is therefore '$(basename $0)'
There are $# things on the line

The 1st command line argument or parameter was '$1'
The 2nd command line argument or parameter was '$2'
The 3rd command line argument or parameter was '$3'
The 4th command line argument or parameter was '$4'
The 5th command line argument or parameter was '$5'

EOF

shift ; echo shifted

cat <<EOF

There are $# things on the line

The 1st command line argument or parameter was '$1'
The 2nd command line argument or parameter was '$2'
The 3rd command line argument or parameter was '$3'
The 4th command line argument or parameter was '$4'
The 5th command line argument or parameter was '$5'

EOF


shift ; echo shifted


cat <<EOF

There are $# things on the line

The 1st command line argument or parameter was '$1'
The 2nd command line argument or parameter was '$2'
The 3rd command line argument or parameter was '$3'
The 4th command line argument or parameter was '$4'
The 5th command line argument or parameter was '$5'


EOF
