# T test and Visualizing data --------------------------------------------------------------
# The following could be made into a function :)))

# Separating the samples --> Ready for Welch Two Sample t-test
T <- my_data_clean_aug %>% 
  filter(site_class == 0) 
Z <- my_data_clean_aug %>% 
  filter(site_class == 1) 

# Welch Two Sample t-test from baseR

# OTU_Count
t.test(x = select(T,OTU_Count), y = select(Z, OTU_Count), var.equal=FALSE)
# p-value = 0.02473 = Means are NOT significantly different
ggplot(description_data, aes(x = OTU_Count)) +
  geom_histogram(aes(y = ..density.., fill = site), position = "identity", alpha=0.5, bins=30) +
  geom_density(aes(color = site))
# It recommends to set bins = 30, however I dont know if it maniulates the visualisation

# pH
t.test(x = select(T,pH), y = select(Z,pH), var.equal=FALSE)
# p-value = 3.728e-11 = Means are significantly different
# plotting to see the two distributions 
ggplot(description_data, aes(x = pH)) +
  geom_histogram(aes(y = ..density.., fill = site), position = "identity", alpha=0.5) +
  geom_density(aes(color = site), size = 1) 

# Temp
t.test(x = select(T,Temp), y = select(Z,Temp), var.equal=FALSE)
# p-value < 2.2e-16 = Means are significantly different
ggplot(description_data, aes(x = Temp)) +
  geom_histogram(aes(y = ..density.., fill = site), position = "identity", alpha=0.5, bins=30) +
  geom_density(aes(color = site))
# It recommends to set bins = 30, however I dont know if it maniulates the visualisation

# TS
t.test(x = select(T,TS), y = select(Z,TS), var.equal=FALSE)
# p-value < 2.2e-16 = Means are significantly different
ggplot(description_data, aes(x = TS)) +
  geom_histogram(aes(y = ..density.., fill = site), position = "identity", alpha=0.5, bins=30) +
  geom_density(aes(color = site))
# It recommends to set bins = 30, however I dont know if it maniulates the visualisation

