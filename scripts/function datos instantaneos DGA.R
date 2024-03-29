f_datos_instantaneos_DGA<-function(df) {
  ##### calculos intermedios #####
  ### se puede sacar periodo, coordenadas, estaci�n, codigo, cuenca,area drenaje etc###
  estaci�n<-df[5,4]
  periodo<-df[4,1]
  mes_a�o<-data.frame(df[10,3])
  colnames(mes_a�o)<-("x")
  mes_a�o<-mes_a�o %>% separate(x, c("mes", "a�o"))
  mes<-as.numeric(mes_a�o[1,1])
  a�o<-as.numeric(mes_a�o[1,2])
  ##### borrar informaci�n no necesaria #####
  df<-df[-c(seq(1,10)),-c(4,6,7,12,13,14,15,20,21)] ###borro filas superiores
  df<-df[-(nrow(df)),]                              ###borro fila inferior
  ###
  a<-rep(c("DIA",
           "HORA",
           "ALTURA",
           "CAUDAL"),3)
  colnames(df) <- a                                 ###nombre encabezado
  df<-df[-1,-c(3,7,11)]                             ###borro encabezado y altura
  ##### ordenar data frame #####
  df<-rbind(df[1:3],
            setNames(df[4:6], names(df)[1:3]),
            setNames(df[7:9], names(df)[1:3]))      ###junto datos serie de columnas
  df$A�O<-a�o                                       ###a�ado columna a�o
  df$MES<-mes                                       ###a�ado columna mes
  df<-df[, c(4,5, 1, 2, 3)]                         ###reordeno
  df<-df %>% separate(HORA, c("HORA", "MINUTO"))    ###separo hora/minuto
  
  df$DIA<-as.numeric(df$DIA)                        ###valor numerico dia
  df$HORA<-as.numeric(df$HORA)                      ###valor numerico hora
  df<-df[, -5] 
  df$CAUDAL<-signif(as.numeric(df$CAUDAL))
  #df <-df[order(df$ymdh),]
  
  df$FECHA<-with(df, ymd_h(paste(A�O, MES, DIA, HORA, sep= ' ')))
  df <-df[order(df$FECHA),]
  ##### plotear ####
  grafico<-ggplot(data = df, aes(x = FECHA, y = CAUDAL))+
    geom_line() +
    labs(title="Caudal en estaci�n:",subtitle=estaci�n,
         x=periodo, 
         y="CAUDAL (m3/s)")+
    scale_y_continuous(breaks=c(seq(0,2000,100)))+
    theme_bw()
  ##### output #####
  df<-data.frame(df$FECHA,df$CAUDAL) 
  return(list(grafico,df))
}