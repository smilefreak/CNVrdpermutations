#Exports functions we use in permutation MPI

permuteSample <- function(segmentationResultsForSample,st,windows,randomize_start=F){
        chr_end = segmentationResultsForSample[nrow(segmentationResultsForSample),4] 
        ranks=seq(1,nrow(segmentationResultsForSample))
        reorder_ranks=sample(ranks,replace=F)
        segmentationResultsForSample = segmentationResultsForSample[reorder_ranks,]
         print('here')
        # Improve speed of this horrible for loop lol
        if (randomize_start == F) {
            for( i in 1:nrow(segmentationResultsForSample)){
                dif = segmentationResultsForSample[i,4] - segmentationResultsForSample[i,3] + windows
                segmentationResultsForSample[i,3] = st
                segmentationResultsForSample[i,4] = st  + dif - windows
                st = st + dif
            }
            return(segmentationResultsForSample)
        } else {
            # Randomize the start of thi
            start_of_list = data.frame()
            end_of_list = data.frame() 
            no_more = F 
            random_start=sample(1:((chr_end/1000)-1),1) 
            st = st + random_start * 1000
            end_of_list_count = 1
            first = T
            for( i in 1:nrow(segmentationResultsForSample)){
                dif = segmentationResultsForSample[i,4] - segmentationResultsForSample[i,3]     
                if(st == chr_end){
                    st = 0
                    no_more = T 
                    end_of_list = segmentationResultsForSample[i,]
                    end_of_list[end_of_list_count,3] = st
                    end_of_list[end_of_list_count,4] = (st + dif - chr_end)
                    end_of_list_count = end_of_list_count + 1
                    st = st + dif
                }else if((st + dif) > chr_end){
                    if ( first == T ){
                        start_of_list = segmentationResultsForSample[i,] 
                        first = F 
                    } else if ( first == F ) {
                    start_of_list[i,]  = segmentationResultsForSample[i,]
                    }
                    start_of_list[i,3] = st
                    start_of_list[i,4] = chr_end
                    no_more = T  
                    end_of_list=segmentationResultsForSample[i,]
                    end_of_list[end_of_list_count,3] = 0
                    end_of_list[end_of_list_count,4] = (st + dif - chr_end)
                    end_of_list_count = end_of_list_count + 1 
                    st = (st + dif - chr_end)
                }else{
                    if( no_more == T ) {
                        end_of_list[end_of_list_count, ] = segmentationResultsForSample[i, ]
                        end_of_list[end_of_list_count, 3] = st
                        end_of_list[end_of_list_count, 4] = st + dif
                        end_of_list_count = end_of_list_count + 1
                        st = st + dif
                    }else if( no_more == F ){
                        if ( first == T ){
                            start_of_list = segmentationResultsForSample[i,]
                            first = F
                        }else if ( first == F ) {
                            start_of_list[i,]  = segmentationResultsForSample[i,]
                        }
                        start_of_list[i,] = segmentationResultsForSample[i,]
                        start_of_list[i,3] = st 
                        start_of_list[i,4] = st + dif
                        st = st + dif
                    }
                }
            }
            print(rbind(end_of_list,start_of_list))
            return(rbind(end_of_list,start_of_list))
        }
}
