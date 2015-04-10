elm-make src/*.elm

for f in index.html elm.js; do
  cp $f ../kyle.marek-spartz.org/salem
done

pushd ../kyle.marek-spartz.org && \
.cabal-sandbox/bin/site deploy && \
popd
