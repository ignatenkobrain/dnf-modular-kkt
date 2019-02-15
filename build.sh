#!/bin/sh -euf

rm -vrf repo

rpmbuild -D "_rpmdir $PWD/repo" -ba test-app.spec
rpmbuild -D "_rpmdir $PWD/repo" -ba kkt.spec -D "ver 30"
rpmbuild -D "_rpmdir $PWD/repo" -ba kkt.spec -D "ver 80"

createrepo_c repo
modifyrepo_c --mdtype modules modules.yaml repo/repodata/
