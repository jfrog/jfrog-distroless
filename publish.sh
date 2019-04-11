#!/bin/bash
PROGNAME="publish.sh"

function usage(){
	echo "Usage: ./$PROGNAME BUILD file directory"
}

function exit_error(){
	echo $1
	exit 1
}

function publish() {
	DIRECTORY=$1
	TAG=$2
	cd $DIRECTORY
	#Change to tag to include the build number
	sed -i -e "s/@BUILD_NUMBER@/$TAG/g" BUILD
	bazel run publish
}

function main() {
#Verify BUILD_NUMBER is set
if [ -z "$BUILD_NUMBER" ]; then
    exit_error "BUILD_NUMBER env was not set"
fi

i=0
BUILDS=[]
BASE="$PWD"
files=$(find . -name 'BUILD'  -type f)
echo "${files[@]}"| while read line
do
    if grep -q container_push "$line"; then
    BUILD_DIR=$(echo $line | rev | cut -c 7- | rev)
    publish ${BUILD_DIR} ${BUILD_NUMBER}
    cd $BASE
fi
    (( i++ ))
done


}

main "$@"
