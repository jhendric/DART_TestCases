#!/bin/tcsh -f

# copying directory 
if ( $#argv > 0 ) then
   set LOG_DIR = $1
else
   set LOG_DIR = `pwd`
endif

set num_nodes = 32

set BAD_DIR = "$LOG_DIR/bad_logs"

echo "extracting times from $LOG_DIR"

#### '---------10--------20--------30--------40--------50--------60--------70--------80--------90
echo '--------------------------------------- CHEYENNE -------------------------------------------------------------------------'
echo '| case    | ES | TPN  | NDS  | CPUS   | read | assim | write_r | filter | CH    | DATE TIME           | COMP MPI'
echo '|---------|----|------|------|--------|------|-------|---------|--------|-------|---------------------|-------------------'

foreach file (`ls -rt *.o[0-9]*`)
  # first grab stuff from log file
  @ tskpn = 0
  @ nodes = 32 

  set compiler = `grep -Po 'intel/[^ ]+' $file`
  set mpi      = `grep -Po 'mpt/[^ ]+' $file`
  set file_t   = `stat $file | grep Change | cut -d' ' -f2,3 | cut -d'.' -f1`
  
  
  if ($mpi == '') set mpi = `grep -Po 'impi/[^ ]+' $file`
  if ($mpi == '') set mpi = `grep -Po 'openmpi/[^ ]+' $file`

  set ncpus = `grep "NCPUS" $file | awk '{print $2}' | cut -d"'" -f2`
  set nodes = `grep "NODES" $file | awk '{print $2}' | cut -d"'" -f2`

  if ($nodes == '') then
     @ nodes = 32 
  endif  

  if ($ncpus == '') then
     @ ncpus = 0 
  endif  

  #  this grabs case.log 
  set case_number = `echo $file | rev | cut -d'o' -f1 | rev`
  set      cutoff = `grep "cutoff namelist value is"                $file | awk '{print $9}'`
  set     num_obs = `grep "Ready to assimilate up to"               $file | awk '{print $9}'`
  set    ens_size = `grep "running with an ensemble size of"        $file | awk '{print $10}'`
  set task_count  = `grep "initialize_mpi_utilities:  Running with" $file | awk '{print $6}'`
 
  # if ($ncpus == 0) then
  set ncpus = `echo "$task_count" | bc`
  # endif 

  @ tskpn = ($ncpus / $nodes)

   # echo "ncpus nnodes tskpn  " "$ncpus" "$nodes" "$tskpn" 

  if ("$ens_size" == "") then
     set ens_size = 0
  endif

  # grab times
  set     filter_start = `grep "Filter start TIME" $file | awk '{print $5}'`
  set    filter_finish = `grep "Filter done TIME"  $file | awk '{print $5}'`

  if ("$filter_finish" != "") then
     set   read_start  = `grep "Before reading in ensemble restart files TIME" $file | awk '{print $9}'`
     set   read_finish = `grep "After  reading in ensemble restart files TIME" $file | awk '{print $9}'`
     set  assim_start  = `grep "Before observation assimilation TIME"          $file | awk '{print $6}'`
     set  assim_finish = `grep "After  observation assimilation TIME"          $file | awk '{print $6}'`
     set writer_start  = `grep "Before state space output TIME"                $file | awk '{print $7}'`
     set writer_finish = `grep "After  state space output TIME"                $file | awk '{print $7}'`
     set   filter_time = `echo $filter_start $filter_finish | ~/source/./subtime | awk '{print $1}'` 
     set     read_time = `echo   $read_start   $read_finish | ~/source/./subtime | awk '{print $1}'` 
     set   writer_time = `echo $writer_start $writer_finish | ~/source/./subtime | awk '{print $1}'`  
     set    assim_time = `echo  $assim_start  $assim_finish | ~/source/./subtime | awk '{print $1}'`  

     if ("$writer_time" == "") then
        set writer_time = "0000"
     endif

  else
     echo "'vi $file' did not finish. Consider moving to bad_logs. 'mv $file bad_logs/'  "
     # mkdir -p $BAD_DIR
     # mv *$case_number* $BAD_DIR
     continue
  endif

  if ($nodes == '') then
     set num_nodes  = `echo 32 | bc`
     set core_hours = `python -c "print (1.0*$num_nodes*($filter_time/3600.0))"`
  else
     set num_nodes  = `echo "$nodes" | bc`
     set core_hours = `python -c "print (1.0*$num_nodes*($filter_time/3600.0))"`
  endif

  #        | case| ES  | NP  | cut   | obs  | read| ass | wrt  |filt | CH    | TIME       | COMP MPI
#    echo '| case| ES  | TPN | NDS   | CPU  | read| ass | wrt  |fil  | CH    | DATE TIME  | COMP MPI'
  printf  "| %7d | %2d | %4d | %2d   | %5d  | %4d | %5d | %6d  | %6d | %5.1f | %-10s %-8s | %-10s %-10s\n" \
          $case_number  \
          $ens_size \
          $tskpn \
          $nodes \
          $task_count \
          $read_time  \
          $assim_time \
          $writer_time \
          $filter_time \
          $core_hours \
          $file_t \
          $compiler \
          $mpi
end

echo '--------------------------------------------------------------------------------------------------------------------------'

exit(0)

