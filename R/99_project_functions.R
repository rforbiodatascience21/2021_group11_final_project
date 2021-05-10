

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
    summarise(Max = max(eval(as.symbol(attribute))), 
              Min = min(eval(as.symbol(attribute))), 
              l = length(eval(as.symbol(attribute)))) %>% 
    mutate(width = (Max - Min)/l)
  
  # Bar plot with normalized binwidth
  bacterium_attribute_barplot <- ggplot(data = bacterium_data, 
                                        mapping = aes(x = eval(as.symbol(attribute)), 
                                                      y=OTU_Count, 
                                                      fill=site)) +
    geom_bar(stat="identity", 
             position="identity", 
             width = pull(binwidth,
                          width), 
             alpha = 0.5) +
    labs(x = attribute, 
         y = "OTU_Count", 
         title = bacterium) + 
    theme(legend.position = "bottom", 
          legend.title = element_blank())
  
  return(bacterium_attribute_barplot)
}


creating_attribute_violinplot <- function(attribute){
  # This function creates a violinplot with the desired attribute 
  # on the y-axis and site on the y-axis 
  # The parameter must be inputted as a string.

  attribute_violin <- my_data_clean_aug %>% 
    ggplot(aes(x = site, 
               y = eval(as.symbol(attribute)), 
               fill = site)) +
    geom_violin(alpha=0.7) +
    geom_boxplot(width = 0.05, 
                 color = "grey35", 
                 alpha = 0.7, 
                 outlier.size = 0.5) +
    labs(y = attribute, 
         title = paste("Sample", attribute)) +
    theme(legend.position = "none")

  return(attribute_violin)
}

creating_correlation_pointplot <- function(attribute1, attribute2){
  # This function creates a pointplot with the desired two attributes 
  # The parameters must be inputted as a strings.
 
  correlation_pointplot <- my_data_clean_aug %>%
    ggplot(aes(x = eval(as.symbol(attribute1)), 
               y = eval(as.symbol(attribute2)))) +
    geom_point(size = 3, 
               alpha=0.7, 
               color="darkolivegreen2") +
    labs(title=paste("Point plot of", attribute1, "vs.", attribute2)) +
    theme(legend.title = element_blank())
    
    return(correlation_pointplot)
}

run_kmeans <- function(data, n_clusters) {
  # This function runs Kmeans
  # The parameters are a tibble and either an integer,
  # e.g. 3 and a seq eg. 1:9
  cluster <- tibble(k = n_clusters) %>%
    mutate(kclust = map(k, 
                        ~kmeans(data, 
                                .x)),
           # One row summary
           tidied = map(kclust, 
                        tidy),
           # Add specifications about the clusters
           glanced = map(kclust,
                         glance),
           # Add the cluster classifications to every data point
           augmented = map(kclust,
                           augment,
                           data))
  return(cluster)
}


