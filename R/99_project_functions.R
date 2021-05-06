creating_bacterium_barplot <- function(bacterium, attribute){
  # This function creates a barplot of with the desired attribute 
  # on the x-axis and OTU_count on the y-axis for the desired 
  # bacterium. The parameters must be inputted as strings.
  
  # Extracting data concerning the desired bacterium
  bacterium_data <- my_data_clean_aug %>%
    filter(Taxa == bacterium) %>%
    filter(OTU_Count > 0)

  # Normalizing binwidth for the barplot
  binwidth <- bacterium_data %>% 
    summarise(Max = max(eval(as.symbol(attribute))), Min = min(eval(as.symbol(attribute))), l = length(eval(as.symbol(attribute)))) %>% 
    mutate(width = (Max - Min)/l)
  
  # Bar plot with normalized binwidth
  p1 <- ggplot(data = bacterium_data, mapping = aes(x = eval(as.symbol(attribute)), y=OTU_Count, fill=site)) +
    geom_bar(stat="identity", position="identity", width = pull(binwidth,width), alpha = 0.5) +
    labs(x = attribute, y = "OTU_Count", title = bacterium) + 
    theme(legend.position = "bottom", legend.title = element_blank())
  
  return(p1)
}

