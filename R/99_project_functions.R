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
  bacterium_attribute_barplot <- ggplot(data = bacterium_data, mapping = aes(x = eval(as.symbol(attribute)), y=OTU_Count, fill=site)) +
    geom_bar(stat="identity", position="identity", width = pull(binwidth,width), alpha = 0.5) +
    labs(x = attribute, y = "OTU_Count", title = bacterium) + 
    theme(legend.position = "bottom", legend.title = element_blank())
  
  return(bacterium_attribute_barplot)
}


creating_attribute_violinplot <- function(attribute){
  # This function creates a violinplot with the desired attribute 
  # on the y-axis and site on the y-axis 
  # The parameter must be inputted as a string.

  attribute_violin <- my_data_clean_aug %>% 
    ggplot(aes(x = site, y = eval(as.symbol(attribute)), fill = site)) +
    geom_violin(alpha=0.7) +
    geom_boxplot(width = 0.05, color = "grey35", alpha = 0.7, outlier.size = 0.5) +
    labs(y = attribute, title = paste("Sample", attribute)) +
    theme(legend.position = "none")

  return(attribute_violin)
}



