#!/bin/bash
### WARNING !!!!! STUDENTS MUST NOT CHANGE/EDIT THIS FILE !!!
### You might accidentally delete/change your files or change the intention of the test case
###   if you make changes to this sript without understanding the consequences.
### This script is intended to be executed in mimi using the bash shell.

check_for_script()
{
    if [[ ! -f "$1" ]]
    then
        echo "Script '$1' not found. Please make sure to upload the mini tester script into the same folder as your scripts."
        exit 1;
    fi
}

print_and_run()
{
    echo "\$ $1"
    bash -c "$1"
    echo -e "$2exit code: $?"
}

print_archive()
{
    echo "BEGIN ARCHIVE <<<"
    tarfile=$(find $1 -iname "*.tar")
    tar xvf $tarfile -O 2>&1
    echo ">>> END ARCHIVE"
}

check_for_script "backup.sh"
check_for_script "srcdiff.sh"

# BEGIN SETUP
scriptdir=$PWD
tmpdir=/tmp/__tmp_comp206_${LOGNAME}
mkdir -p "$tmpdir"
cp backup.sh srcdiff.sh "$tmpdir"
cd "$tmpdir"
mkdir -p "$tmpdir/test_files"
echo "This is my first text file!" > "$tmpdir/test_files/file_1.txt"
echo -e "#Example configuration file\nvar=value" > "$tmpdir/test_files/file_2.conf"
echo -e "#Another configuration file" > "$tmpdir/test_files/file_3.conf"

# test backup.sh
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  backup.sh tests @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
dirToBackup="$tmpdir/test_files/"
backupDir="$tmpdir/backups"
mkdir -p "$dirToBackup"
mkdir -p "$backupDir"
fileToBackup="$(basename "$dirToBackup")/file_3.conf"

echo
echo "[[[[ FAIL - incorrect usage ]]]]"
echo "********************************************************************************"
print_and_run "./backup.sh $backupDir"
echo "********************************************************************************"
echo
echo "[[[[ FAIL - backup directory does not exist]]]]"
echo "********************************************************************************"
print_and_run "./backup.sh /not_a_directory $dirToBackup"
echo '********************************************************************************'
echo
echo '[[[[ WORKS - directory (absolute path) ]]]]'
echo '********************************************************************************'
rm "$backupDir"/* 2>/dev/null
print_and_run "./backup.sh $backupDir $dirToBackup"
print_archive "$backupDir"
echo '********************************************************************************'
echo
echo '[[[[ WORKS - file (relative path) ]]]]'
echo '********************************************************************************'
rm "$backupDir"/* 2>/dev/null
print_and_run "./backup.sh $backupDir $fileToBackup"
print_archive "$backupDir"
echo '********************************************************************************'
echo
# Overwrite $fileToBackup, see if backup.sh overwriting works.
printf 'Testing overwriting the file...\n' > "$fileToBackup"
echo '[[[[ WORKS - overwrite (n) ]]]]'
echo '********************************************************************************'
print_and_run "echo n | ./backup.sh $backupDir $fileToBackup"
print_archive "$backupDir"
echo '********************************************************************************'
echo
echo '[[[[ WORKS - overwrite (y) ]]]]'
echo '********************************************************************************'
print_and_run "echo y | ./backup.sh $backupDir $fileToBackup" "\n"
print_archive "$backupDir"
echo '********************************************************************************'
echo
echo
# test srcdiff.sh
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  srcdiff.sh tests @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
originalDir="$tmpdir/test_files/"
copyDir="$tmpdir/copy_dir"
diffDir="$tmpdir/diff_dir"
emptyDir="$tmpdir/empty_dir"
cp -r "$originalDir" "$copyDir"
cp -r "$originalDir" "$diffDir"
mkdir -p "$emptyDir"
rm "$diffDir/file_1.txt"
echo -e "#Another configuration file" > "$diffDir/file_3.conf"
echo -e "#!/bin/bash\necho \"Hello world!\"" > "$diffDir/file_4.sh"

echo
echo "[[[[ FAIL - incorrect usage ]]]]"
echo "********************************************************************************"
print_and_run "./srcdiff.sh"
echo "********************************************************************************"
echo
echo "[[[[ FAIL - input parameter #1 is a file instead of a directory ]]]]"
echo "********************************************************************************"
print_and_run "./srcdiff.sh $originalDir $copyDir/file_1.txt"
echo "********************************************************************************"
echo
echo "[[[[ WORKS - original directory vs identical copy ]]]]"
echo "********************************************************************************"
print_and_run "./srcdiff.sh $originalDir $copyDir"
echo "********************************************************************************"
echo
echo "[[[[ WORKS - original directory vs different directory ]]]]"
echo "********************************************************************************"
print_and_run "./srcdiff.sh $originalDir $diffDir"
echo "********************************************************************************"
echo
echo "[[[[ WORKS - empty directory vs different directory ]]]]"
echo "********************************************************************************"
print_and_run "./srcdiff.sh $emptyDir $diffDir"
echo "********************************************************************************"
echo

# CLEAN UP
rm -r "$tmpdir"
