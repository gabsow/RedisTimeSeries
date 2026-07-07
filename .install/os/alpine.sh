#!/usr/bin/env bash
# Alpine Linux. ALPINE_BASE in lib/packages.sh already includes the musl-specific
# extras (musl-dev, linux-headers, gcompat, libstdc++, libgcc, bsd-compat-
# headers, ...) that used to live in a separate quirks file.
#
# The py3-* prebuilt packages avoid building those C extensions against musl
# from source during pip install; openblas-dev / xsimd back math/SIMD test
# deps.

# shellcheck source=../lib/packages.sh
. "$LIB/packages.sh"

alpine_default_install
apk_install py3-cryptography py3-numpy py3-psutil openblas-dev xsimd

# uv's standalone musl CPython is built with clang and bakes clang-only
# flags (--rtlib=compiler-rt) into its sysconfig, so sdist-only deps that
# lack musl wheels (psutil==5.9.8 via rltest) fail to compile with
# /usr/bin/cc (gcc). Point the venv at Alpine's own python3 instead
# (already installed above together with the headers).
SETUP_PYTHON_VERSION="$(command -v python3)"
export SETUP_PYTHON_VERSION
