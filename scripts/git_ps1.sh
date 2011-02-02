#!/bin/bash
if ! (type -p __git_ps1); then
	. /etc/bash_completion
fi
if ! (type -p __git_ps1); then
	exit 1
fi
__git_ps1
exit $?

