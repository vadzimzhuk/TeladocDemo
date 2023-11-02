# Teladoc Health Senior Mobile Engineer Interview
### Assessment
#### Instructions
Please pick at least one of the following two assignments to complete. The assignment should
be a complete operational mobile app for either iOS (objective-c / swift) or Android (Java /
Kotlin) that can run on the relevant simulator. Your solution should be able to compile and run
on the latest Xcode or Android Studio. Any other special instructions should be provided in an
included README. Prior to the panel interview please share a public GitHub link or a zip file of
your application code for review.
### Question 1 - Algorithms and Data Structures
O Romeo, Romeo, wherefore art thou Romeo?
Included with this assignment is the file Romeo-and-Juliet.txt. It is a classic tale of family, death
and forbidden love! Write an application that will read this file and generate a list of all word
occurrences. Label each word with the frequency with which it is used. The application should
display the results in a TableView / RecyclerView ordered from most to least frequently used.
Extra credit: Build a control that allows the table view to sort itself instead of alphabetically or
by character length of the word.
### Question 2 – Networking and Asynchronous Operations
#### Twist and Shout!
iTunes search API allows you to find a bunch of information quickly and easily from Apple’s
iTunes database as JSON response. With simple search terms and parameters, you can request
all the albums by 1960’s international mega star rock band The Beatles! Write an application
that will request the albums by The Beatles, parse the JSON and display all the album titles in a
TableView / RecyclerView.
Extra credit: Include functionality that would allow someone to search their own favorite
artist from the API and display the results.
#### API URL:
https://itunes.apple.com/search?term=thebeatles&amp;media=music&amp;entity=album&amp;attribute=artistTerm
#### API Documentation:
https://performance-partners.apple.com/search-api

## Implementation
Implemented both tasks, placed in the same project, but separated by targets Q1 and Q2
### Architecture
MVVM+Coordinator
### Dependencies
DIContainer
### Network layer
Standart Foundation tools
