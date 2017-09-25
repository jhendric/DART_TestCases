#! /bin/tcsh -f
# copying directory 
if ( $#argv > 0 ) then
   set LOG_DIR = $1
else
   set LOG_DIR = `pwd`
endif

set BAD_DIR = "$LOG_DIR/bad_logs"

echo "extracting times from $LOG_DIR"

#### '---------10--------20--------30--------40--------50--------60--------70--------80--------90
echo 'case   | ES |   NP | cut  | obs    | read | assim | write_r | filter | CH    |'
echo '-------|----|------|------|--------|------|-------|---------|--------|-------|'

foreach file (`ls -rt $LOG_DIR/*.log`)
  # first grab stuff from log file

  #  this grabs case.log 
  set case_number = `echo $file | rev | awk -F. '{print $2}' | rev`

  set      cutoff = `grep "cutoff namelist value is"                $file | awk '{print $9}'`
  set     num_obs = `grep "Ready to assimilate up to"               $file | awk '{print $9}'`
  set    ens_size = `grep "running with an ensemble size of"        $file | awk '{print $10}'`
  set task_count  = `grep "initialize_mpi_utilities:  Running with" $file | awk '{print $6}'`
  if ("$ens_size" == "") then
     set ens_size = 0
  endif
  # grab times
  set  filter_start = `grep "Filter start TIME" $file | awk '{print $5}'`
  set filter_finish = `grep "Filter done TIME"  $file | awk '{print $5}'`
  if ("$filter_finish" != "") then
     set    read_start = `grep "Before reading in ensemble restart files TIME"        $file | awk '{print $9}'`
     set   read_finish = `grep "After  reading in ensemble restart files TIME"        $file | awk '{print $9}'`
     set   assim_start = `grep "Before observation assimilation TIME"                 $file | awk '{print $6}'`
     set  assim_finish = `grep "After  observation assimilation TIME"                 $file | awk '{print $6}'`
     #set  writep_start = `grep "Before prior state space diagnostics TIME"            $file | awk '{print $8}'`
     #set writep_finish = `grep "After  prior state space diagnostics TIME"            $file | awk '{print $8}'`
     #set  writer_start = `grep "Before state space output TIME" $file | awk '{print $10}'`
     #set writer_finish = `grep "After  state space output TIME " $file | awk '{print $10}'`
     set  writer_start = `grep "Before state space output TIME" $file | awk '{print $7}'`
     set writer_finish = `grep "After  state space output TIME" $file | awk '{print $7}'`
     set filter_time = `echo $filter_start $filter_finish | ~/bin/./subtime | awk '{print $1}'` 
     set   read_time = `echo   $read_start   $read_finish | ~/bin/./subtime | awk '{print $1}'` 
     #set writep_time = `echo $writep_start $writep_finish | ~/bin/./subtime | awk '{print $1}'`  
     set writer_time = `echo $writer_start $writer_finish | ~/bin/./subtime | awk '{print $1}'`  
     set  assim_time = `echo  $assim_start  $assim_finish | ~/bin/./subtime | awk '{print $1}'`  
     if ("$writer_time" == "") then
        set writer_time = 0000
     endif
  else
     echo "$case_number did not finish. Consider mv *$case_number* bad_dir"
     # mkdir -p $BAD_DIR
     # mv *$case_number* $BAD_DIR
     continue
  endif

  set core_hours = `python -c "print (1.0*$task_count*($filter_time/3600.0))"`

     # case   | ES  | NP  | cut   | obs | read| assim| writer |filter | CH    |
  printf "%6d | %2d | %4d | %3.2f | %6d | %4d | %4d  |    %4d | %4d   | %5.2f | \n" \
          $case_number  \
          $ens_size \
          $task_count \
          $cutoff \
          $num_obs \
          $read_time  \
          #$writep_time \
          $assim_time \
          $writer_time \
          $filter_time \
          $core_hours

end

exit(0)

