# 9/13 Exercise Answers 

## Answer 1.1 

- To calculate the total amount of nucleotides sequenced, we multiply the sequence length by the amount of coverage, 1Mbp * 3 = 3Mbp
- Then we divide the total amount of nucleotides by the amount of nucleotides per read, 3Mbp/100bp = 30000
- Thus we need 30,000 reads to achieve the ideal amount of coverage 

## Answer 1.2
- See 9-13-exercise.py code 

## Answer 1.3 
- See 9-13-exercise.R code

## Answer 1.4
- 45787 nucleotides have not been covered using our simulation 
- 49787 nucleotides have not been covered using the poisson R simulation
- 51393 nucleotides have not been covered using the normal R simulation

## Answer 1.5
- See 9-13-exercise.py and 9-13-exercise.R code
- 76 nucleotides have not been covered using our simulation 
- 45.4 nucleotides have not been covered using the poisson R simulation
- 850 nucleotides have not been covered using the normal R simulation

## Answer 1.6
- See 9-13-exercise.py and 9-13-exercise.R code
- 8 nucleotides have not been covered using our simulation 
- 9.36*10^(-8) nucleotides have not been covered using the poisson R simulation
- 0.0223 nucleotides have not been covered using the normal R simulation

## Answer 2.4
- "./9-13-exercise.py > edges.txt"
- Pipe the digraph list with the edges into a text file
- "dot -Tpng ./edges.txt -o ex2_digraph.png"
- Make a digraph using the text file created

## Answer 2.5
- ATTCTTATTCATTGATTT

## Answer 2.6
- Firstly, we divided the genome into overlapping reads of 5-mers, the value for k has to be carefully chosen as if k is too small, too many repeating k-mers in the genome would cause ambiguity resulting the genome have too many variations while reconstructing, thus we chose k=3 allowing each reads to have two edges. We would then create a De bruijn graph using the two edges where the edges act as nodes. Then we would want to find a Eulerian path which means that every path between these edges will be walked exactly once thus creating the complete genome sequence. 