#!/usr/bin/bash

# UA.SH - Universal Automation
# Currently backs up /home/jianyu/gitrepo to /home/jianyu/backup

# TODO: Expand for more functionality, maybe a restore

HOME_DIR=/home/jianyu
REPO_DIR=${HOME_DIR}/gitrepo
BACKUP_DIR=${HOME_DIR}/backup
COPIES_TO_KEEP=5

# Argument handler
if [[ $1 == '-h' || $1 == '-help' || -z $1 ]]; then
    echo 'Usage: backup.sh [-h | -help]'
    echo '                 [-b | -backup [backupfile]]'
    exit 1
elif [[ $1 == '-b' || $1 == '-backup' ]]; then
    if [[ ! -z $2 ]]; then
        TAR_FILE=$2
    fi
else
    echo ' (*) Bad arguments provided, unable to run.'
    exit 1
fi

# Count number of copies in BACKUP_DIR with *.tar
CURRENT_COPIES=$(/usr/bin/find ${BACKUP_DIR} -type f -printf x | wc -c)

# Remove copies past retention period
if [[ ${CURRENT_COPIES} -ge ${COPIES_TO_KEEP} ]]; then
    COPIES_TO_REMOVE=$((${CURRENT_COPIES} - ${COPIES_TO_KEEP} + 1))
    EARLIEST_BACKUP="$(/usr/bin/ls -t ${BACKUP_DIR} | tail -${COPIES_TO_REMOVE})"

    # For safety, to ensure rm -rf does not delete more than backup files
    if [[ -z ${BACKUP_DIR} || -z ${EARLIEST_BACKUP} ]]; then
        echo ' (*) FATAL: Execution of /usr/bin/rm -rf on empty variable, terminating!'
        exit 1
    fi

    # Remove each outdated file
    for BACKUPFILE_OLD in "${EARLIEST_BACKUP}"; do
        /usr/bin/rm -rf ${BACKUP_DIR}/${BACKUPFILE_OLD}
        if [[ $? == 0 ]]; then
            echo ' (*) Removed' ${BACKUPFILE_OLD} 'due to retention of' ${COPIES_TO_KEEP} 'copies.'
        else
            echo ' (*) Unable to remove backup.'
        fi
    done
fi

# Set backup file name, D - date, T - time, N - nanoseconds (to create a unique file)
if [[ -z ${TAR_FILE} ]]; then
    echo ' (*) Using default backup file name ...'
    TAR_FILE=gitrepo_D$(date '+%Y%m%d')_T$(date '+%H%M%S')_N$(date '+%N').tar
fi

# Execute backup
echo ' (*) Backing up to' ${BACKUP_DIR} '...'
tar -cvf ${BACKUP_DIR}/${TAR_FILE} ${REPO_DIR} > /dev/null 2>&1 &

# Return opcode
if [[ $? == 0 ]]; then
    echo ' (*) Backup of' ${TAR_FILE} 'successful.'
else
    echo ' (*) Backup of' ${TAR_FILE} 'failed!'
fi

