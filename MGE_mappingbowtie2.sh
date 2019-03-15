#!/bin/bash
module load biokit
while read i
do
	name=($i)
	bowtie2 -x MGEs -1  ../$name"_HostRM_merged_R1.fastq" -2 ../$name"_HostRM_merged_R2.fastq" -D 20 -R 3 -N 1 -L 20 -i S,1,0.50 \
	--threads 8 | samtools view -Sb - > $name.bam
	samtools view -h $name".bam" | awk '$7!="=" || ($7=="=" && and($2,0x40)) {print $0}' | samtools view -Su  - \
	| samtools sort -o $name"_sort.bam"
	samtools index $name"_sort.bam"
	samtools idxstats $name"_sort.bam" | grep -v "*" | cut -f3 > $name"_counts"
	samtools idxstats $name"_sort.bam" | grep -v "*" | cut -f1 > gene_names
	echo -e "$name" > new_name
	paste header new_name > temp
	mv -f temp header 
	echo -e	"$name"	>> bowtie2_progress
done < ../names
	paste  gene_names *_counts | cat header - > genemat.txt
