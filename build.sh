#!/bin/sh -euf

rm -vrf repo

rpmbuild -D "_rpmdir $PWD/repo" -ba test-app.spec
rpmbuild -D "_rpmdir $PWD/repo" -ba kkt.spec -D "ver 10"
rpmbuild -D "_rpmdir $PWD/repo" -ba kkt.spec -D "ver 30"

createrepo_c repo
modifyrepo_c --mdtype modules modules.yaml repo/repodata/
