# Team name: doIt()

## Level of Achievement: Apollo 11

### Project Description: 

Summit is a productivity app which aims to help us manage our tasks and schedule. More specifically, we aim to build a seamless integration between Summit and LumiNUS – NUS’s module and assignment platform.

Our mobile application would be built on the Flutter, cross-platform framework, allowing us to conveniently cater to both Android and iOS users. All data would be stored on Google Firebase and our source code control system is Git.

Our implementation timeline is as follows:

Phase 1: 
-	Familiarise ourselves with Flutter and Dart programming language through online tutorials
-	Building our mock-up UI and UX flow through Figma
-	Setting up Google Firebase as our cloud database
-	Implementing online authentication (email and password) for our users
-	Building our app skeleton 
-	Implementing the basic To-Do List (adding, completing and deleting tasks) and Calendar Page functionality (adding of event name, date and time)

Phase 2:
-	Connecting our To-Do List to Firebase, allowing for the storing of data based on user email 
-	Implementing a due and reminder date-time for our To-Do List
-	Adding event markers to our calendar to indicate the presence of events at a every date
-	Connecting our Calendar Page to Firebase, allowing for the storing of data based on user email 
-	Implementation of a progress bar, keeping track of the percentage of tasks completed overall and for each category.
-	Release of new app icons based on the number of tasks completed 
-	Allowing users to change their app icons


Phase 3:
-	Notifications (Android) to remind users of their tasks
(Notifications would only be implemented on Android as iOS charges a fee)
-	Improving the storage of data (for to-do list)
-	Implementing a progress bar to keep track of the percentage of tasks completed on time
-	Implementing authentication services through LumiNUS
-	Connecting our database to LumiNUS to allow for the automatic pulling of tasks and calendar events from LumiNUS
-	Improve the entire UI of our app (ensuring a consistent UI, building smoother transitions through animations)

[FrontEnd/BackEnd WalkThrough](https://drive.google.com/file/d/1ovEeuez4GGploSDG_n-z5kdTIl9vDXIl/view?usp=sharing)

+++++++++++++

Aim: To create an application to improve the productivity levels of NUS students.

Target audience: NUS Students

Problem Statement: 
>As students, we participate in many different activities, be it handling our modules, joining CCAs or committees. This causes us to often lose track of our tasks at hand, causing us to miss deadlines or be late for meetings. 

>While there are many planner apps in the market, we identified a few key problems with them:

>Having to manually key in all of our tasks and lessons is extremely troublesome
Most planner apps do not include features to encourage us to remain productive


## Our Solution: 

We created a planner app which includes a calendar and to-do list. Our app would be integrated with LumiNUS, allowing for lectures and tutorial timeslots to be displayed on the calendar. The quizzes and homework would be displayed in our to-do list. 
We would be including a simple gamification feature into our app. There will be a page which tracks the user’s progress for each module, showing the percentage of tasks they have completed for that module. This serves to be a reality check for the user, ensuring that they do not lag behind in any modules. 
Additionally, we have a rewards system, whereby as the user completes tasks, he would be able to win new app icons.

## Tech Stack:
    -Flutter
    -FireBase
    -LumiNUS API
    -Git

Testing:
As of phase 2, we have conducted developer and user testing with 3 individuals. During phase 3, we would be conducting more robust testing systems. 

[UI/UX Prototype](https://drive.google.com/file/d/1QaSjk1qGhQfM8YVW1si3e7FY4kyx8elP/view?usp=sharing)

[Milestone 1 App Walkthrough](https://youtu.be/Ih9LIYMVL5k)

[Milestone 2 App Walkthrough](https://youtu.be/Wsk-k_lVZTY)

[UX Program Flow](https://drive.google.com/file/d/17OUUayTRPn0P3Pa_KmxGoqzXls1L8SR3/view)

[Poster Link](https://docs.google.com/presentation/d/1n6n6FBOJjyZbyPo2389HsmWM8EyCu0vq77wNdqc_Vkw/edit?usp=sharing)

[Project Log](https://docs.google.com/spreadsheets/d/1QzaLbCOcQz6imKT6Gw6qvRGGeeXJ6V3ohopMn0OgsLA/edit#gid=0)

### Problems Encountered during Milestone 2
1. During milestone 2, we connected our to-do list, calendar, progress bar and rewards page to a FireBase database. The storing of data into firebase went smoothly, but we struggled with the retrieval of data. For all of the above 4 features, we spent substantial time ensuring the our app actively listened to the database and no hot reload was required for new data to be displayed on our app. The main issue we faced was due to the listening of data / streams from firebase being asynchronous.

2. Initially, we planned to implement notifications for Milestone 2. However, we realised that the implementation of notifications on iOS is subjected to charges. We then began trying to implement notifcations on Android instead, but were unable to retrieve the app token key for firebase cloud messenging. We would continue reading up on the steps to implementing notifications on Android.

3. For our calendar page, we faced issues with allowing the added events to show automatically, without hot reload. (i.e. upon adding of events, the calendar marker reflects the added event immediately, but not the "words" below). This issue is likely linked to issue 1.

4. As we were struggling with connecting our to-do list to firebase initially, the storage of information is not optimal. Currently the database is stored as such: User email --> categories and tasks instead of User email --> categories --> tasks. Additionally, the progress tracker and reward features connection with the database is not optimal. Currently, it is connected based on catgeory name, which is not necessarily a unique identifier / primary key. This would result in errors if 2 categories were to have the same name.  
