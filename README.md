# Zadanie testowe dla firmy **APZUMI**
Wrzesień 2018  
<br> 

## Treść zadania:

**Używając języka Swift, napisać aplikację spełniającą następujące wymagania:**

* składa się z 2 ekranów:
	* z listą elementów
	* ze szczegółami po wybraniu elementu listy

* aplikacja pobiera dane wyświetlane na liście z 2 różnych API:
   * Bitbucket: <https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description>
   * GitHub: <https://api.github.com/repositories>
* element listy składa się z:
	* nazwy repozytorium
	* nazwy użytkownika
	* avatara właściciela
* ekran ze szczegółami zawiera:
	* nazwę repozytorium
	* nazwę użytkownika
	* avatar właściciela
	* opis repozytorium
* elementy pobrane z API Bitbucket powinny być wyróżnione (w dowolny sposób)
* lista ma możliwość włączenia lub wyłączenia sortowania elementów w kolejności alfabetycznej (po nazwie repozytorium)
* paginacja nie jest wymagana