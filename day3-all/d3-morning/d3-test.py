#!/usr/bin/env python3

import sys 

for i in range(len(L)):
    if L[i] < max:
        continue 
    else: 
        max = L(i)
print(max)

total = [0, 0, 0, 0]
count = [0, 0, 0, 0]
for i in range(len(L)): 
    for j in range(len(L[i])): 
        total[j] += L[i][j]
        count[j] += 1

for i in range(len(total)): 
    print(total[i]/count[i])
