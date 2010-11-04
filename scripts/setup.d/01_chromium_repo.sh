#!/bin/sh
cat << EOF > /etc/yum.repos.d/chromium.repo
[fedora-chromium]
name=Chromium web browser and deps
baseurl=http://repos.fedorapeople.org/repos/spot/chromium/fedora-\$releasever/\$basearch/
enabled=1
gpgcheck=0

[fedora-chromium-source]
name=Chromium web browser and deps - Source
baseurl=http://repos.fedorapeople.org/repos/spot/chromium/fedora-\$releasever/SRPMS/
enabled=0
gpgcheck=0
EOF

