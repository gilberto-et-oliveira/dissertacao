
library("devtools")

#remotes::install_github("gearslaboratory/gdalUtils")
library(gdalUtils)

#install_github("s5joschi/accessibility")
# once installed just activate the package with
library(AccessibilityMaps)

library(raster)


# DADO DE USO E COBERTURA COM CLASSES TRANSFORMADAS EM Km/H E INSERIDAS AS VIAS
r_landcover <-
  raster(
    # CAMETA
    #"D:/INPE_DISCIPLINAS/Dissertacao/raster/mapbiomas/2010/mapbio_CAMETA_collec7_2010_Km_VIAS_wgs84.tif"
    # "D:/INPE_DISCIPLINAS/Dissertacao/raster/mapbiomas/2020/mapbio_CAMETA_collec7_2020_Km_VIAS_wgs84.tif"
    
    #STR
    #"D:/INPE_DISCIPLINAS/Dissertacao/raster/mapbiomas/2010/mapbio_STR_collec7_2010_Km_VIAS_wgs84.tif"
    "D:/INPE_DISCIPLINAS/Dissertacao/raster/mapbiomas/2020/mapbio_STR_collec7_2020_Km_VIAS_wgs84.tif"
    )
plot(r_landcover)


# MODELO DIGITAL DE TERRENO - TOPODATA
r_dem<-
  raster(
    # CAMETA
    #"D:/INPE_DISCIPLINAS/Dissertacao/raster/topodata/cameta/DEM_cameta_wgs84_recort.tif"
    
    #STR
    "D:/INPE_DISCIPLINAS/Dissertacao/raster/topodata/str/DEM_str_wgs84_recort.tif"
  )
plot(r_dem)


# Create radiansmap
r_radians <-
  acc_radians(
    my_input = r_dem,
    my_baselayer = r_landcover,
    resampling_method = "near")

plot(r_radians)


# CORREÇAO NA VELOCIDADE DO DADO DE USO E COBERTURA COM VIAS A PARTIR DO DEM 
r_landcover_reclass_corr <-
  acc_slopecorr(my_input = r_landcover,
                my_radians = r_radians)

plot(r_landcover_reclass_corr)


# EXPORTAR O RASTER
writeRaster(r_landcover_reclass_corr,
            "D:/INPE_DISCIPLINAS/Dissertacao/raster/mapbiomas/2020/mapbio_STR_collec7_2020_Km_VIAS_COR_wgs84.tif",
            format="GTiff",
            overwrite=TRUE
            )
