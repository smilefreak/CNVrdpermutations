#expand_each_row <- function(matrix_row,row_length,subRegionData,subRegionOrig){
#    subRegionRow  <- rep(NA,row_length)
#    for (i in 1:nrow(subRegionOrig)){
#        start_position <- subRegionOrig[i,1] 
#        end_position  <- subRegionOrig[i,2]
#        startSeq = findInterval(x=start_position,vec=subRegionData[,1])
#        endSeq = findInterval(x=end_position,vec=subRegionData[,2])
#        while(subRegionData[endSeq,2] <= end_position && endSeq <= length(subRegionData[endSeq,2])){
#            endSeq <- endSeq + 1
#        }
#        indexes = seq(from=startSeq,to=endSeq)
#        subRegionRow[indexes] <- matrix_row[i]
#        # need to test this function to ensure it works as expected
#    }
#    return(subRegionRow)
#}
#
#stretch_seg  <- function(segment_scores,w_size=1000){
#    st=0
#    en=as.matrix(segment_scores$subRegion)[length(as.matrix(segment_scores$subRegion))]
#    subRegionData  <- data.frame(seq(st,en-w_size,w_size),seq(st+w_size,en,w_size))
#    sampleids <- rownames(segment_scores$subRegionMatrix)
#    row_length  <- tail(subRegionData,n=1)[2]/w_size
#    subRegionMatrix = apply(segment_scores$subRegionMatrix,1,expand_each_row,row_length=row_length,subRegionData=subRegionData,subRegionOrig=segment_scores$subRegion)
#    subRegionMatrix = t(subRegionMatrix)
#    segment_scores$subRegionMatrix  <- subRegionMatrix
#    segment_scores$subRegionData  <- subRegionData
#    return(segment_scores)
#}
## PRetty sure this works
stretch_seg  <- function(segment_scores,w_size=1000){
    st = 0
    en=as.matrix(segment_scores$subRegion)[length(as.matrix(segment_scores$subRegion))]
    subRegionData  <- data.frame(seq(st,en-w_size,w_size),seq(st+w_size,en,w_size))
    sampleids <- rownames(segment_scores$subRegionMatrix)
    subRegionMatrix  = stretchToWindowSize(segment_scores$subRegionMatrix,segment_scores$subRegion[,1],segment_scores$subRegion[,2],w_size)
    rownames(subRegionMatrix) = sampleids
    segment_scores$subRegionMatrix  <-  subRegionMatrix
    segment_scores$subRegionData  <-  subRegionData
    return(segment_scores)
}
