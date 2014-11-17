permuteChromosome <- function(task){
    chr  <- task[2]
    i <- task[1]
    st  <- task[3]
    en = task[4]
    windows  <- task[5]
    sample_list  <- sample_list_per_chromosome[[chr]]
    print('printueuou')
    result <- lapply(sample_list,permuteSample,st=st,windows=windows,randomize_start=T)
    result <- list(segmentResults=result)
    polyMorphicResampling = getSubRegionMatrixFromSegmentScores(segmentResults=result$segmentResults,window_size = windows,st,en)
    return(list(i=i,chr=chr,result=polyMorphicResampling))
}

