#Ximena Karaman Lian 
#202021348
#Repo ximenakaraman

##Problemset 2
#R version 4.3.1 (2023-06-16)

#   Descargar las bibliotecas necesarias para manipular bases de datos
library(pacman)
p_load(rio, 
       data.table, 
       tidyverse, 
       haven, 
       skimr, 
       janitor) 

# Se fijo la carpeta en la cual se va a trabajar, donde esta la informacion necesaria para el problemset2 y las carpetas creadas para almacenar la informacion
setwd("~/Library/CloudStorage/OneDrive-UniversidaddelosAndes/2023-2/R/problemset_2/") 


#    2.1 Importar las bases de datos
  # Paso 1:Se importo la base de datos con la cual vamos a trabajar location
    location <- read_dta("~/Library/CloudStorage/OneDrive-UniversidaddelosAndes/2023-2/R/problemset_2/input/Módulo de sitio o ubicación.dta")
    View(location) #Para visualizar la base de datos importada

  # Paso 2:Se importo la base de datos con la cual vamos a trabajar identification
    identification <- read_dta("~/Library/CloudStorage/OneDrive-UniversidaddelosAndes/2023-2/R/problemset_2/input/Módulo de identificación.dta")
    View(identification) #Para visualizar la base de datos importada


#    2.2 Exportar a la carpeta de output
    setwd("output/") #Se fija la carpeta en la cual se exportaran las bases de datos
    saveRDS(object = location, file = "location.rds") #Se exporto a la carpeta de output la base de datos de location
    saveRDS(object = identification, file = "identification.rds") #Se exporto a la carpeta de output la base de datos de identification


#   3 Generar variables 

#   3.1 
    #Como la variable de interes que es GRUPOS4, no es una variable con datos numericos, es necesario volver los caracteres (01,02,03,04) a valores numericos, con el fin de operar con la variable
    identification$GRUPOS4 <- as.numeric(identification$GRUPOS4) 
    #A cada valor numerico, se asignamos un nombre/categoria, con el cual se identifica la rama de actividad segun CIIU
    identification <- mutate(identification, bussiness_type=case_when(GRUPOS4==1~"Agricultura", 
                                                                      GRUPOS4==2~"Industria_manufacturera", 
                                                                      GRUPOS4==3~"Comercio", 
                                                                      GRUPOS4==4~"Servicios")) 
    
#   3.2
    #Se genera nueva variable, y le asigna el valor 1 cuando la variable P3053 toma valores de 6 o 7.
    location <- mutate(location, local=case_when(P3053==6~"1",
                                                 P3053==7~"1")) 

  
#   4 Eliminar filas/columnas de un conjunto de datos

#   4.1
    # el objeto "identification_sub" recibe el conjunto de datos específicos a partir de la función subset para obtener únicamente los datos de industria manufacturera de la variable "bussiness_type"
    identification_sub <- subset(identification, bussiness_type=="Industria_manufacturera")

#   4.2
    # el objeto "location_sub" recibe las variables específicas (7) de DIRECTORIO, SECUENCIA_P, SECUENCIA_ENCUESTA, P3054, P469, COD_DEPTO y F_EXP obtenidas del objeto "location"
    location_sub <- subset(location, select=c(DIRECTORIO, 
                                              SECUENCIA_P, 
                                              SECUENCIA_ENCUESTA, 
                                              P3054, 
                                              P469, 
                                              COD_DEPTO, 
                                              F_EXP))
        #No es necesario, pero se exporta la base de datos a la carpeta de output 
        saveRDS(object = location_sub, file = "location_sub.rds")
    
#   4.3
    # ahora el objeto "identification_sub" se va a componer de las variables especificadas (10) en el enunciado: DIRECTORIO, SECUENCIA_P, SECUENCIA_ENCUESTA, P35, P241, P3032_1, P3032_2, P3032_3, P3033 y P3034
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
      #No es necesario, pero se exporta la base de datos a la carpeta de output 
      saveRDS(object = identification_sub, file = "identification_sub.rds")

#       5
    # la nueva base llamada "location_sub_X_identification_sub" va a tener los elementos de ambas bases excluyendo las variables repetidas (como unión de conjuntos) para un total de 14 variables en conjunto
    location_sub_X_identification_sub <- merge(location_sub, identification_sub, by = c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA"))
    
      #No es necesario, pero se exporta la base de datos a la carpeta de output 
      saveRDS(object = location_sub_X_identification_sub, file = "location_sub_X_identification_sub.rds")
