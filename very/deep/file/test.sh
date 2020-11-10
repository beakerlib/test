#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Description: Set of basic file utilities
#   Author: Petr Splichal <psplicha@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGE="coreutils"
PHASE=${PHASE:-Test}

rlJournalStart
    rlPhaseStartSetup
        rlRun "rlImport coreutils/file"
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    # Create file
    if [[ "$PHASE" =~ "Create" ]]; then
        rlPhaseStartTest "Create"
            fileCreate
        rlPhaseEnd
    fi

    # Self test
    if [[ "$PHASE" =~ "Test" ]]; then
        rlPhaseStartTest "Test default name"
            fileCreate
            rlAssertExists "$fileFILENAME"
        rlPhaseEnd
        rlPhaseStartTest "Test filename in parameter"
            fileCreate "parameter-file"
            rlAssertExists "parameter-file"
        rlPhaseEnd
        rlPhaseStartTest "Test filename in variable"
            FILENAME="variable-file" fileCreate
            rlAssertExists "variable-file"
        rlPhaseEnd
    fi

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalEnd
