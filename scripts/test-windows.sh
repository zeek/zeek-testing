#/usr/bin/env /bin/bash

_updating=0
while [ $# -ne 0 ]; do
    case "$1" in
	-U)
	    _updating=1
	    ;;
	*)
            echo "Invalid option '$1'"
            exit 1
            ;;
    esac
    shift
done

# Grab some paths that are needed through the script
SCRIPTPATH=$(dirname $(realpath $0))
TESTPATH=$(dirname $SCRIPTPATH)
REPOPATH=$(realpath ${SCRIPTPATH}/../../../..)
BUILDPATH=${REPOPATH}/out/build/x64-Debug

# Add btest to the path so that we can use btest-diff
export PATH=${PATH}:${REPOPATH}/auxil/btest

# Set up some variables needed for btest-diff to work right
export BaselineDir=${TESTPATH}/Baseline.windows
export TEST_DIFF_CANONIFIER=$(realpath "${REPOPATH}/testing/scripts/diff-canonifier-external")
if [ ${_updating} -eq 0 ]; then
    export TEST_MODE="TEST"
else
    export TEST_MODE="UPDATE"
fi

# Source the script that sets up all of the environment
# needed to run zeek, along with a few other things we'll
# need.
. ${BUILDPATH}/zeek-path-dev.sh
TRACES=${TESTPATH}/Traces
ZEEKPATH=${ZEEKPATH}:${REPOPATH}/testing/external/scripts

for _testfile in $(ls -1 ${TESTPATH}/tests); do
    _testname=$(echo ${_testfile} | cut -d . -f 1)
    _testpcap=$(grep -o '\$TRACES.*' ${TESTPATH}/tests/${_testfile} | awk '{print $1}')

    echo -n "${_testname}... "

    # These are needed by btest-diff but are specific to each test
    export TEST_BASELINE=${TESTPATH}/Baseline.windows/tests.${_testname}
    export TEST_DIAGNOSTICS="${TESTPATH}/.tmp/tests.${_testname}/.diag"

    mkdir -p .tmp/tests.${_testname}
    pushd .tmp/tests.${_testname} >/dev/null 2>&1

    cat _testpcap | gunzip | ${BUILDPATH}/src/zeek.exe -G ${REPOPATH}/testing/btest/random.seed -r - ${TESTPATH}/tests/${_testfile}
#    ${BUILDPATH}/src/zeek.exe -G ${REPOPATH}/testing/btest/random.seed -r ${HOME}/Desktop/ipv6.trace ${TESTPATH}/tests/${_testfile} >.stdout 2>.stderr

    ${REPOPATH}/testing/external/scripts/diff-all *.log >>.stdout 2>>.stderr
    if [ $? -eq 0 ]; then
	echo "OK"
	popd >/dev/null 2>&1
	rm -r ${TESTPATH}/.tmp/tests.${_testname}
    else
	echo "Failed"
	echo
	cat ${TEST_DIAGNOSTICS}
	popd >/dev/null 2>&1
    fi

    exit
done
