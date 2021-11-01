#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SEGMENTS_DIR=${SCRIPT_DIR}/../segments4

mkdir ${SEGMENTS_DIR}
cd ${SEGMENTS_DIR}
wget http://brouter.de/brouter/segments4/W10_N35.rd5
wget http://brouter.de/brouter/segments4/W10_N40.rd5
