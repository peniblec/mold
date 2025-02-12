#!/bin/bash
export LC_ALL=C
set -e
CC="${CC:-cc}"
CXX="${CXX:-c++}"
testname=$(basename "$0" .sh)
echo -n "Testing $testname ... "
cd "$(dirname "$0")"/../..
mold="$(pwd)/ld64.mold"
t=out/test/macho/$testname
mkdir -p $t

cat <<EOF | $CC -o $t/a.o -c -xc -
#include <stdio.h>
void hello() {
  printf("Hello world\n");
}
EOF

! clang -fuse-ld="$mold" -shared -o $t/b.dylib $t/a.o -Wl,-pagezero_size,0x1000 >& $t/log
fgrep -q ' -pagezero_size option can only be used when linking a main executable' $t/log

echo OK
