
#install.packages("spdep")
#install.packages("spatialreg")
#install.packages("spgwr")
#install.packages("Rcpp")

library(tidyverse)
library(sf)
library(spdep)
library(spatialreg)
library(spgwr)
library(dplyr)
library(rgdal)

grade_OGR <- readOGR("D:/INPE_DISCIPLINAS/Dissertacao/shapes/_exemplos_testes/grade5kmSTR_NEIBANA_DEM_c.shp")

plot(grade_OGR, col = grade_OGR$B0_Amplitu)

w <- poly2nb(pl = grade_OGR, 
             row.names = grade_OGR$id,
             queen=T) # aqui pode mudar se quiser queen ou rook


grade_df <- grade_OGR@data
head(grade_df  )

#grade_df[is.na(grade_df)] <- 0

for (c in colnames(grade_df)){
  if ( c == 'id' || c == 'col' || c == 'row'){ # colunas que não serão analisadas
   print( paste('coluna não será analisada ->',c)  )
  }
  else{ 
    print(paste('metricas de vizinhança da coluna:', c))
    for (linha in (1: length(grade_df$id)) ){ # células
      col_viz_geral <- ''
      col_viz_queen <- ''
      col_viz_geral <- paste(c, "_global", sep='') 
      col_viz_queen <- paste(c, "_queen", sep='')
      viz <- 0
      for ( i in w  ){# vizinhança
        for ( cel in i  ){ # celulas da vizinhança
          viz <- viz + grade_df[cel, c]
        }
        viz <- viz / length(i) # média da vizinhança
      }
      grade_df[linha, col_viz_queen] <- grade_df[linha, c] - viz
      grade_df[linha, col_viz_geral] <- grade_df[linha, c] - (sum( grade_df[linha, c])/length(grade_df$id)  )
    }
    print( paste('métricas para',c, 'calculadas') )
  }
  }


colnames(grade_df)
head(grade_df)

hist(grade_df$B0_Max_Val_queen)

write.csv(grade_df,"D:/INPE_DISCIPLINAS/Dissertacao/tabelas/estats_STR_500m_MAPBIO_WPop.csv") #choose your file location

