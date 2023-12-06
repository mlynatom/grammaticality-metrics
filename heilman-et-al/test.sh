#!/usr/bin/bash

STANFORDHOME="/home/mlynatom/stanford-parser-full-2020-11-17/"

homedir="$(cd "$(dirname "$0")"; pwd)"
wkdir="/home/mlynatom/grammaticality-metrics/heilman-et-al"
learnerlm="/home/mlynatom/grammaticality-metrics/nonnative.arpa"
nativelm="/home/mlynatom/grammaticality-metrics/native_giga.arpa"
test=$1

parser_cmd="java -cp $STANFORDHOME/*: edu.stanford.nlp.parser.lexparser.LexicalizedParser \
    -outputFormat \"oneline,typedDependencies\" \
    -sentences newline \
    -printPCFGkBest 1 \
    -writeOutputFiles \
    -outputFilesDirectory $wkdir/parsed \
    edu/stanford/nlp/models/lexparser/englishPCFG.ser.gz"

feat_cmd="python3 $homedir/feature_extractor.py \
    -p $wkdir/parsed/ \
    -d features \
    --giga $nativelm \
    --toefl $learnerlm"

mkdir $wkdir/parsed 2> /dev/null
mkdir $wkdir/features 2> /dev/null

$(cd /home/mlynatom/grammaticality-metrics/heilman-et-al/)

for f in $test; do
	if [ "$f" = "" ]; then
		continue
	fi

    bn=`basename $f`
    # parse
    if [ ! -s $wkdir/parsed/$bn.stp ]; then
	echo "Parsing $f..."
	eval "$parser_cmd $f"
	echo "Done"
    fi
    # extract features
    if [ ! -s "$wkdir/features/$bn.json" ]; then
	echo "Extracting features from $f..."
	eval "$feat_cmd -f $f"
	echo "Done"
    fi
done