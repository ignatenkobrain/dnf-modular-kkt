# How does DNF do dependency resolution wron (for modularity)

## What does DNF do today?

1. Resolves dependencies between modules (and consider them as enabled)
2. Filter out RPMs which are in non-enabled modules (exclude, disable)
3. Install RPMs from profile

## So what's wrong with it?

It resolves dependencies between modules and rpms at different points of time.

## Example

We have `test-app` rpm which depends on `kkt >= 25`. And we have 2 `kkt`
build versions: `10` and `30`.

And they are packed into a modules as following:

* `kkt:master:2019:deadbeef:x86_64`
  * Contains `kkt-30-1.x86_64`
* `kkt:master:2019:bbadbeef:x86_64`
  * Contains `kkt-10-1.x86_64`
* `test-app:master:2019:deadbeef:x86_64`:
  * Contains `test-app-1-1.x86_64`
  * Requires `kkt: []`

That means, if you would be about to install `test-app`, you would get
`test-app-1-1` and `kkt-30-1`… But not with DNF. What you will get is:

```
Error:
 Problem: package test-app-1-1.x86_64 requires kkt >= 25, but none of the providers can be installed
  - conflicting requests
  - package kkt-30-1.x86_64 is excluded
```

Try it yourself!

```
$ ./build.sh
$ sudo rm -rf /var/cache/dnf/test*
$ sudo dnf --repofrompath=test,$PWD/repo module install test-app
```

## How come that different contexts have different versions of RPM?

Well, you can easily do so. Just depending on your dependencies you can change
your RPM.

But it can be same version, but it can have some conflicts in place.
You can do all that in RPM.
