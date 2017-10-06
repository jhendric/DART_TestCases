#!/usr/bin/python

import sys, os
# import numpy as np
# import matplotlib.pyplot as plt

file  =  sys.argv[1]
ptile = int(sys.argv[2])

print 'file:', file

# partition file with memory information from job_mem_usage.exe
table     = []
proc_list = []
mem_list  = []

n = 1
for line in open(file,'r'):
   if "Used memory" in line:
      info = line.split()

      procinfo = info[4]
      meminfo  = info[5]

      proc = n
      # proc, sep, tail = procinfo.partition('/') 
      mem,  sep, tail = meminfo.partition('MiB') 

      # nprocs = procinfo.partition('/')[2]
      # nprocs = nprocs.replace(":","")
      # nprocs = int(nprocs)
      
      # print 'processor : ', proc
      # print 'memory    : ', mem
      
      proc_list.append(int(proc)) 
      mem_list.append(float(mem)) 
      # print 'procs[', int(proc), '] , memory = ', float(mem), ' MiB'
      # print 'procs[ {%d} ] , memory = {%f} MiB'.format(int(proc),float(mem))
      n = n + 1 

# split up table into processors b, and MiB s
table = zip(proc_list, mem_list)
s     = sorted(table, key=lambda x: int(x[0])) # MiB per processor
b     = zip(*s) # processor number

# sum up the memory per node
MiBtoGB = 0.00104858

node = 1
nodemem = 0
node_mem_list = []
for info in s:
     if (info[0]%ptile==0 and info[0] != 0):
        node_mem_list.append(float(nodemem)) 
        node    = node+1
        nodemem = 0
        
     nodemem = nodemem + info[1]*MiBtoGB

nprocs = n-1
print 'nprocs ', nprocs 

nnodes   = nprocs / ptile 
totalMiB = sum(b[1])
totalGB  = totalMiB*MiBtoGB 
avg_mem  = totalGB/nprocs

# print results for memory usage
print ' ' 
print 'num procs : ', nprocs
print 'num nodes : ', nnodes
# print 'sum_mem   : ', totalMiB, 'MiB'
# print '            ', totalGB,  'GB' 
print 'avg mem   : ', avg_mem*ptile,  'GB/node'
print 'max mem   : ', max(node_mem_list), 'GB'
print ' ' 

# print total peak memory used on each node
node_mem = 0.0
node     = 1
for i in range(len(b[0])):
   node_mem = node_mem + b[1][i]*MiBtoGB
   if b[0][i]%ptile == ptile-1:
      print 'node {0:3d} mem = {1:5f} GB'.format(node, node_mem)
      node_mem = 0.0
      node     = node + 1

