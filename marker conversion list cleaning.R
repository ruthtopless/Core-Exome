# make file uppercase
core.exome.ID.conversion.upper<- toupper(core.exome.ID.conversion)

# find number of unique marker ids in target marker column
# could use this file but doesn't gie you control over which IDs are picked. 
uniquelist<-core.exome.ID.conversion.upper[unique(core.exome.ID.conversion.upper$TARGET_ID), ]

#find number of duplicated rows in target marker column
duplicatelist<-core.exome.ID.conversion.upper[duplicated(core.exome.ID.conversion.upper$TARGET_ID), ]

#These should add up to the total and help to check that you have removed the correct number of rows etc

#merge the duplicate list with the orginal to get a complete list of the duplications
allduplicates<-merge(core.exome.ID.conversion.upper, duplicatelist, by="TARGET_ID")
allduplicates$SOURCE_ID.y=NULL
write.table(allduplicates, file="allduplicates.txt", quote=F, row.names = F, sep="\t")
#if the row count is more than 2*duplicatelist then you know that you have triplicates in the file

#identify duplicates
library(dplyr)
allduplicates %>% select(TARGET_ID) %>% group_by(TARGET_ID) %>% tally() %>% filter(n>2)

#copy this info into a file for reference.
# not sure how to do the rest in r. I have had to do manually 
# identify in a extra column the triplicate IDs to remove
# identify IDs to keep and remove (preferentially keeping markers labelled with the RS ID oringinally)
# load a file with marker IDs to keep and remove identified in an extra column
# merge original with the new keep/remove list
merged<-merge(core.exome.ID.conversion.upper,allduplicatesfilter, by="SOURCE_ID", all=T)

keepers<-subset(merged, FILTERCOL=="remove" | is.na(FILTERCOL))

#still ended up with extra samples due to complications merging files back together based on SOURCE_ID.
#I think the fix for this would be to create a new column in the first instance that is a combination of SOURCE_ID and TARGET_ID and use that to merge.
#gave up at that point and did it manually. 
