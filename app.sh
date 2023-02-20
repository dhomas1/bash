### BASH ###
_build_bash() {
local VERSION="5.2.15"
local FOLDER="bash-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://ftp.gnu.org/gnu/bash/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
for n in {001..015}; do
  if [[ ! -f "${PWD}/download/bash-${VERSION}-${n}.patch" ]]; then
    wget -O "${PWD}/download/bash-${VERSION}-${n}.patch" "http://ftp.gnu.org/gnu/bash/bash-5.2-patches/bash52-${n}"
  fi
done

for f in ${PWD}/download/bash-${VERSION}-*.patch; do
  pushd "target/${FOLDER}"
  echo "${f}"
  patch -p0 -i "${f}"
  popd
done

pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEST}" --mandir="${DEST}/man"
make
make install
"${STRIP}" --strip-all -R .comment -R .note -R .note.ABI-tag "${DEST}/bin/bash"
popd
}

### BUILD ###
_build() {
  _build_bash
  _package
}
