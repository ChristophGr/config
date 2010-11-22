#!/bin/sh
git filter-branch --commit-filter '
        if [ "$GIT_AUTHOR_EMAIL" = "" ];
        then
                GIT_COMMITTER_EMAIL="e0525747@student.tuwien.ac.at";
                GIT_AUTHOR_EMAIL="e0525747@student.tuwien.ac.at";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' $1..$2

