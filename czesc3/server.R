library(shiny)
library(stringi)

macierz = function(film,wektor,f){
   
   # ustawiamy sciezke do folderu gdzie znajduja sie pliki z macierzami:
   # ladujemy plik zawierajacy wszystkie id filmow wraz z 
   # odpowiadajacymi im tytulami:
   wektor <- as.numeric(wektor)
   #print(wektor)
   nr = which(stri_detect_regex(f[,1],film)==TRUE)
   nazwy = list.files(pattern="macierz")
   nazwy = sort(nazwy)
   
   # wekotr x odpowiada kolejnym numerom macierzy, ktore
   # interesuja nas ze wzgledu na kategorie jaka jest wybeirana
   # w aplikacji:
   x=c(1,1,10,4,13,11,1,2,12,14,7,6,14,3,5,5,2,9,8)
   nowa = matrix(0,nrow=5000,ncol=5000)
   
   for (i in 1:length(nazwy)){
      load(nazwy[i])
      y = nazwy[i]
      y = stri_sub(y,from=8,to=(stri_length(y)-4))
      y = stri_paste('m',y)
      
      nowa = nowa + get(y)*wektor[x[i]]
      rm(list=y)
      gc()
   }
   nowa = nowa/length(x)
   
   kt = which(rownames(nowa)==film)
   
   wartosci <- nowa[kt,]
   wartosci <-sort(wartosci)
   
   # wybeiramy 15 najbardziej podobnych filmow:
   a <- which(rownames(nowa)%in%names(wartosci)[4985:5000])
   
   dane = nowa[a,a]
   rn = rownames(dane)
   dane = matrix(rep(1,256),nrow=16,ncol=16)-dane
   tytul=character(15)
   # Wyciagniecie tytulow filmow ktore sa najbardziej podobne:
   for (i in 1:15){
      tytul[i]=as.character(f[which(stri_detect_regex(f[,1],rn[i])==TRUE),2])
      #print(tytul[i])
   }
   
   # rysowanie mapy:
   mac=as.dist(dane)
   loc=cmdscale(mac)
   x=loc[,1]
   y=loc[,2]
   plot(x,y,type='n',xlab="",ylab="" )
   text(x,y,tytul,cex=0.8)
   
   return(list(tytul,x,y))
}

shinyServer(function(input, output, session) {
   
   kol =c("aktorzy" ,
          "rezyser",
          "producent",
          "gatunek",
          "recenzje",
          "fabula",
          "ocena" ,
          "uzytkownicy",
          "rok",
          "dlugosc",
          "kraj" ,
          "muzyka" ,
          "key",
          "nagrody" )
   
   load("f.rda")
   
   M <- reactive({
      
      input$szukaj
      isolate({
         
         tytul <- isolate(input$Film)
         dane <- input$kryteria
         ktore <- logical(14)
         for(i in 1:14){
            
            if(kol[i]%in%dane) ktore[i] <- TRUE
            
         }
         #print(dane)
         #print(ktore)
         id <- as.character(f[which(f[,2]==tytul),1])
         macierz(id, ktore,f)   
         
      })
      
   })
   
   
   
   output$mapa <- renderPlot({
      input$szukaj
      isolate({
         #       tytul <- isolate(input$Film)
         #       dane <- input$kryteria
         #       ktore <- logical(14)
         #       for(i in 1:14){
         #         
         #         if(kol[i]%in%dane) ktore[i] <- TRUE
         #         
         #       }
         #       print(dane)
         #       print(ktore)
         #       id <- as.character(f[which(f[,2]==tytul),1])
         #       macierz(id, ktore,f)
         x <- M()[[2]]
         y <- M()[[3]]
         tytul2 <- M()[[1]]
         plot(x,y,type='n',xlab="",ylab="" )
         text(x,y,tytul2,cex=0.8)
         
      })
      
   })
   
   output$tabela <- renderTable({
      input$szukaj
      isolate({
         #       tytul <- isolate(input$Film)
         #       dane <- input$kryteria
         #       ktore <- logical(14)
         #       for(i in 1:14){
         #         
         #         if(kol[i]%in%dane) ktore[i] <- TRUE
         #         
         #       }
         #       print(dane)
         #       print(ktore)
         #       id <- as.character(f[which(f[,2]==tytul),1])
         #       a <-macierz(id, ktore,f)
         data.frame(Filmy=M()[[1]])
      })
      
   })
   
})