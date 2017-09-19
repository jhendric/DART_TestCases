#!/bin/bash
#
# This code may (or may not) be part of the COAMPS distribution,
# So it is not protected by the DART copyright agreement.
#
# DART $Id: rel_to_abs_path.sh 6256 2013-06-12 16:19:10Z thoar $
#
########################################################################
#
# SCRIPT:   rel_to_abs_path.sh
# AUTHOR:   T. R. Whitcomb
#           Naval Research Laboratory
#
# Convert a file's relative location to an absolute location.
#
# This is taken from
# http://www.shelldorado.com/shelltips/script_programmer.html
#
# The command line argument is the file's relative location
REL_OUTPUT_FILE=$1
D_NAME=`dirname "$REL_OUTPUT_FILE"`
F_NAME=`basename "$REL_OUTPUT_FILE"`
ABS_PATH=`cd "$D_NAME" 2>/dev/null && pwd || echo \"$D_NAME\"`
OUTPUT_FILE="${ABS_PATH}/${F_NAME}"
echo "$OUTPUT_FILE"

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/shell_scripts/COAMPS_RESTART_SCRIPTS/rel_to_abs_path.sh $
# $Revision: 6256 $
# $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $

