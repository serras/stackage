#!/bin/bash -ex

cabal update
rm -rf patching/tarballs
(cd patching/ && ./scripts/create-tarballs.sh)
cabal install
cabal install Cabal-$(cabal --version | sed -n 's@using version \(.*\) of the Cabal library@\1@p')
./dist/build/stackage/stackage select $*
./dist/build/stackage/stackage check
./dist/build/stackage/stackage build
./dist/build/stackage/stackage test

cabal install http-client --force-reinstalls

for f in inclusive exclusive
do
    cd $f

    bash create-snapshot.sh

    cd ..
done
