# Team name: doIt()

## Level of Achievement: Apollo 11

### Project Description: 

Summit is a productivity application to help users better manage their tasks and schedule. More specifically, it is designed with the National University of Singapore, NUS’s students in mind. Summit integrates seamlessly with NUS’s module and assignment platform, LumiNUS, making it extremely convenient for NUS students to manage their workload. 


Our implementation timeline is as follows:

Phase 1: 
-	Familiarise ourselves with Flutter and Dart programming language through online tutorials
- Building our mock-up UI and UX flow through Figma
- Setting up Google Firebase as our cloud database
- Implementing online authentication (email and password) for our users
- Building our app skeleton
- Implementing the basic To-Do List (adding, completing and deleting tasks) and Calendar Page functionality (adding of event name, date and time)


Phase 2:
- Connecting our To-Do List to Firebase, allowing for the storing of data based on user email
- Implementing a due and reminder date-time for our To-Do List
- Adding event markers to our calendar to indicate the presence of events at a every date
- Connecting our Calendar Page to Firebase, allowing for the storing of data based on user email
- Implementation of a progress bar, keeping track of the percentage of tasks completed overall and for each category.
- Release of new app icons based on the number of tasks completed
- Allowing users to change their app icons



Phase 3:
- Notifications (Android) to remind users of their tasks (Notifications would only be implemented on Android as iOS charges a fee)
- Implementing authentication services through LumiNUS
- Automatic pulling of files (module, name, due date) into to-do list
- Automatic pulling of timetable (module, tutorial/lecture/seminar, date, time and location) into calendar
- Improve the entire UI of our app based on user-testing results
- Bug fixes


+++++++++++++

Aim: To create an application to improve the productivity levels of NUS students.

Target audience: NUS Students

Problem Statement: 
>As students, we participate in many different activities, be it handling our modules, joining CCAs or committees. This causes us to often lose track of our tasks at hand, causing us to miss deadlines or be late for meetings. 

>While there are many planner apps in the market, we identified a few key problems with them:

>Having to manually key in all of our tasks and lessons is extremely troublesome
Most planner apps do not include features to encourage us to remain productive


## Our Solution: 

Summit is a productivity app that comprises 2 main features: a planner and a progress tracker. The planner serves the same functionalities as a regular calendar and to-do list. As for the progress tracker, it allows the user to view the percentage of tasks they have completed for each category, ensuring that they do not lag behind in any particular category. Additionally, we included a simple gamification feature into our app to reward players with new app icons upon completion of tasks. 
For NUS students, they also have the option of using the app through their school account. This allows us to automatically pull their lecture, tutorial and lab timeslots into the calendar -- saving them the trouble of manually updating their timetable. Additionally, all files and their associated closing dates would be automatically added into the to-do list. This not only makes it more convenient but also ensures that users do not miss their assignment deadlines. 


## Tech Stack:
Summit is a cross-platform mobile application, catering to both Android and iOS users. 
- Flutter and Dart: Frontend UI and backend framework
- FireBase authentication: Cloud authentication service
- FireBase firestore: Cloud database
- LumiNUS API: OAuth and student, module and timetable data
- Git: Source code control system
- Postman: API Testing
- Chrome DevTools: To identify the specific LumiNUS API to use

Testing:
We conducted developer and user testing. The detailed feedback gained from user testing is documented in the full [README](https://docs.google.com/document/d/1gvgXmNRDetz8hdCAwKdJmzVgw_XsodYEqnI3xGRCp3g/edit#). 

[README](https://docs.google.com/document/d/1gvgXmNRDetz8hdCAwKdJmzVgw_XsodYEqnI3xGRCp3g/edit#)

[Milestone 1 App Walkthrough](https://youtu.be/Ih9LIYMVL5k)

[Milestone 2 App Walkthrough](https://youtu.be/Wsk-k_lVZTY)

[Poster Link](https://docs.google.com/presentation/d/1n6n6FBOJjyZbyPo2389HsmWM8EyCu0vq77wNdqc_Vkw/edit?usp=sharing)

[Project Log](https://docs.google.com/spreadsheets/d/1QzaLbCOcQz6imKT6Gw6qvRGGeeXJ6V3ohopMn0OgsLA/edit#gid=0)


