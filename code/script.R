#Ximena Karaman Lian 
#202021348

##Problemset 2
#R version 4.3.1 (2023-06-16)

library(pacman)
p_load(rio, 
       data.table, 
       tidyverse, 
       haven, 
       skimr, 
       janitor) #Descargar las bibliotecas necesarias para manipular bases de datos

setwd("~/Library/CloudStorage/OneDrive-UniversidaddelosAndes/2023-2/R/problemset_2/")

#2.1 Importar las bases de datos
location <- read_dta("~/Library/CloudStorage/OneDrive-UniversidaddelosAndes/2023-2/R/problemset_2/input/Módulo de sitio o ubicación.dta")
View(location)

identification <- read_dta("~/Library/CloudStorage/OneDrive-UniversidaddelosAndes/2023-2/R/problemset_2/input/Módulo de identificación.dta")
View(identification)

#2.2 Exportar a la carpera de output
setwd("output/")
saveRDS(object = location, file = "location.rds")
saveRDS(object = identification, file = "identification.rds")

#3 Generar variables 

#3.1 
identification$GRUPOS4 <- as.numeric(identification$GRUPOS4)
identification <- mutate(identification, bussiness_type=case_when(GRUPOS4==1~"Agricultura", 
                                                                  GRUPOS4==2~"Industria_manufacturera", 
                                                                  GRUPOS4==3~"Comercio", 
                                                                  GRUPOS4==4~"Servicios"))

#3.2
location <- mutate(location, local=case_when(P3053==6~"1", 
                                             P3053==7~"1"))
view(location)


#4 Eliminar filas/columnas de un conjunto de datos

#4.1
identification_sub <- subset(identification, bussiness_type=="Industria_manufacturera")

#4.2
location_sub <- subset(location, select=c(DIRECTORIO, 
                                          SECUENCIA_P, 
                                          SECUENCIA_ENCUESTA, 
                                          P3054, 
                                          P469, 
                                          COD_DEPTO, 
                                          F_EXP))

#4.3
identification_sub <- subset(identification_sub, select = c(DIRECTORIO, 
                                                            SECUENCIA_P, 
                                                            SECUENCIA_ENCUESTA, 
                                                            P35, 
                                                            P241, 
                                                            P3032_1, 
                                                            P3032_2, 
                                                            P3032_3, 
                                                            P3033, 
                                                            P3034))

#5
location_sub_X_identification_sub <- merge(location_sub, identification_sub, by = c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA"))
