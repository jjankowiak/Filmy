
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)



load("f.rda")
tytuly <- as.character(f[,2])

shinyUI(fluidPage(
   
   titlePanel("Filmy"),
   sidebarLayout(
      sidebarPanel(
         helpText("Dzięki tej aplikacji znajdziesz filmy, które z dużym prawdopodobieństwem Ci się spodobają. :) 
                  Wybierz film i kryteria względem których chcesz znaleźć podobieństwo."),
         
         selectInput("Film", "Wybierz film", tytuly),
         
         checkboxGroupInput("kryteria",
                            "Wybierz odpowiednie kryteria podobieństwa",
                            #może jak się wciśnie aktorów to to od razu będzie aktywować macierz aktorzy i rozrzut aktorów i kraj
                            #to samo dla reżyserów
                            #recenzje - i długość i treść?
                            #opis fabuły - macierz dla opisu i dla fabuły
                            c("Aktorzy" = "aktorzy",
                              "Reżyser" = "rezyser",
                              "Producenci" = "producent",
                              "Gatunek" = "gatunek",
                              "Recenzje" = "recenzje",
                              "Opis fabuły" = "fabula",
                              "Oceny" = "ocena",
                              "Liczba użytkowników na IMDb" = "uzytkownicy",
                              "Rok produkcji" = "rok",
                              "Długość trwania" = "dlugosc",
                              "Kraj(e) powstania" = "kraj",
                              "Muzyka" = "muzyka",
                              "Słowa kluczowe" = "key",
                              "Nagrody" = "nagrody"),
                            
                            c("Aktorzy" = "aktorzy",
                              "Reżyser" = "rezyser",
                              "Producenci" = "producent",
                              "Gatunek" = "gatunek",
                              "Recenzje" = "recenzje",
                              "Opis fabuły" = "fabula",
                              "Oceny" = "ocena",
                              "Liczba użytkowników na IMDb" = "uzytkownicy",
                              "Rok produkcji" = "rok",
                              "Długość trwania" = "dlugosc",
                              "Kraj(e) powstania" = "kraj",
                              "Muzyka" = "muzyka",
                              "Słowa kluczowe" = "key",
                              "Nagrody" = "nagrody")),
         
         actionButton("szukaj", "Szukaj")
         
         ),
      
      mainPanel(
         h1("Znalezione filmy"),
         plotOutput("mapa", width = 800),
         tableOutput("tabela")
      )
   )
))