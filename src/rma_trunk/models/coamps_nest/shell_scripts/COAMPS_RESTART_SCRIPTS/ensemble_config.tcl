#!/usr/bin/wish -f

# This code may (or may not) be part of the COAMPS distribution,
# So it is not protected by the DART copyright agreement.
#
# DART $Id: ensemble_config.tcl 6256 2013-06-12 16:19:10Z thoar $
#
########################################################################
#
# createFileOptionFrame
# -----------------
# creates a "option frame" that includes a description, a resizing
# entry, and a button that opens a file choice window.  The action
# can be either chooseFile or chooseDir
proc createFileOptionFrame { frameName desc action shell_var} {
    global optionFrames
    global optData

    set optionFrames($frameName) [frame $frameName]

    # Label
    set frameLabel [label $frameName.label -text $desc -width 25 -anchor e]
    pack $frameLabel -side left -padx 2 -pady 2 -anchor w 

    # Edit box
    set frameEntry [entry $frameName.entry -textvariable optData($shell_var) -width 50]
    pack $frameEntry -side left -expand y -fill x -padx 2 -pady 2 
    
    # File selection button
    set frameButton [button $frameName.button -text "..." -command [list $action $shell_var]]
    pack $frameButton -side left -padx 2 -pady 2  -anchor e
}

# packFrames
# ----------
# Packs the option frames into the main window
proc packOptionFrames {} {
    global optionFrames

    foreach {name optionFrame} [array get optionFrames] {
        pack $optionFrame -side top -padx 5 -pady 5 -anchor e -expand y -fill x
    }
}

# chooseFile
# ----------
# Selects a file
proc chooseFile {varName} {
    global optData
    set optData($varName) [tk_getOpenFile -initialdir ~ -title "Choose a file"]
}

# chooseDir
# ---------
# Selects a directory
proc chooseDir {frName} {
    global optData
    set optData($frName) [tk_chooseDirectory -initialdir ~ -title "Choose a directory" -mustexist false]
}

# writeConfig
# -----------
# Writes out the configuration data into a paths.config file that can be read by initialize_dart.sh
proc writeConfig {} {
    global optData

    set configFile [open "wizard_generated.paths.config" w]
    puts $configFile "# This file automatically generated by ensemble configuration GUI\n"

    foreach { paramName paramValue } [array get optData] {

        # Escape spaces instead of quoting - this will allow for wildcard substitution later
        regsub -all { } $paramValue {\\ } paramValue

        puts $configFile [format "%s=%s" $paramName $paramValue]
    }

    close $configFile
}

##############################

wm title . "DART/COAMPS Experiment Configuration"

# Directories
set frameDir [labelframe .frDirs -text "Directories"]
createFileOptionFrame "$frameDir.coampsHome"        "COAMPS Home Directory:"         "chooseDir" "COAMPS_HOME"
createFileOptionFrame "$frameDir.coampsUtilHome"    "COAMPS Utility Directory:"      "chooseDir" "COAMPS_UTIL_HOME"
createFileOptionFrame "$frameDir.dartHome"          "DART Home Directory:"           "chooseDir" "DART_HOME"
createFileOptionFrame "$frameDir.coampsData"        "COAMPS Data Directory:"         "chooseDir" "COAMPS_DATA"
createFileOptionFrame "$frameDir.dartBase"          "Ensemble experiment directory:" "chooseDir" "DART_BASE"

set frameFile [labelframe .frFiles -text "Files"]
createFileOptionFrame "$frameFile.dartNamelist"      "DART namelist for experiment:" "chooseFile" "DART_NAMELIST"
createFileOptionFrame "$frameFile.coampsNamelist"    "COAMPS namelist:"              "chooseFile" "COAMPS_NAMELIST"
createFileOptionFrame "$frameFile.coampsRestartFile" "COAMPS restart File:"          "chooseFile" "COAMPS_RESTART_FILE"
createFileOptionFrame "$frameFile.restartDat"        "State vector definition:"      "chooseFile" "RESTART_DAT"

packOptionFrames
pack $frameDir -expand y -fill x -padx 5 -pady 5
pack $frameFile -expand y -fill x -padx 5 -pady 5

button .btnWrite -text "Finish" -command { writeConfig; destroy .}
pack .btnWrite -expand y -fill x -padx 5 -pady 5 -side bottom

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/shell_scripts/COAMPS_RESTART_SCRIPTS/ensemble_config.tcl $
# $Revision: 6256 $
# $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $

