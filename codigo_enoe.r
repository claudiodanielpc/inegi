#Código para ENOE

##Paquetería necesaria
if(!require('pacman')) install.packages('pacman')
pacman::p_load(tidyverse,srvyr)


#Cambiar directorio de trabajo
#Si no existe el directorio D:/, pasar a la siguiente línea
if (dir.exists("D:/")) {
  setwd("D:/")
} else {
  setwd("C:/")
}
#Crear carpeta para guardar los datos
dir.create("enoe",showWarnings = FALSE)

#url de descarga. Ejemplo tercer trimestre 2022
url<-"https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/microdatos/enoe_n_2022_trim3_csv.zip"

#Descargar archivo y descomprimir
download.file(url,destfile = "enoe.zip")
unzip("enoe.zip",exdir = "enoe")

#Eliminar zip
file.remove("enoe.zip")

#Leer archivo
enoe<-read.csv("enoe/ENOEN_SDEMT322.csv")%>%
janitor::clean_names()


#Precisiones estadísticas. PEA mujeres

enoe%>%
#Definir estrato, upm y factor de expansión
as_survey(strata=est_d_tri,weight=fac_tri, ids=upm)%>%
#Filtro de entidad y población económicamente activa
filter(ent==9 & clase1==1)%>%
#Filtro de edad
filter(eda>=15)%>%
#Filtro para mujer
filter(sex==2)%>%
#Obtener datos por municipio/alcadía
group_by(mun)%>%
summarise(sexo=survey_total(vartype = c("cv", "ci")))

