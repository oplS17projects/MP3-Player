# MP3-Player

### Statement
This project is an MP3 Player in Racket with clean UI. It includes play/pause/shuffle controls and has a playlist that the user can interact with if they wish to play that song. They can also skip songs or go back to songs as well. It's interesting because it takes most of the core concepts learned in class like recursion, filter and object orientation.

### Analysis

Data abstraction by the ID3 tags as objects from structure.  
Recursively making list of ID3 objects for album/artists.  
Filtering ID3 objects by the album/artists and outputting.  
Functional approaches by recursively processing the album/artists then outputting.  

### External Technologies

The project processes sound by using VLC player with an interactive interface (play/pause controls etc).

### Data Sets or other Source Materials

The source materials included MP3 files on the system which were be played. The files are played in MP3 format which is only supported by VLC.

### Deliverable and Demonstration

Our final deliverable was an MP3 player that had a clean interactive UI allowing for control over the player such as pause/play.

### Evaluation of Results

All of the criteria for the project were met for evaluation (analysis section).    
The player is able to open and play the files successfully and has an interactive UI.  

## Architecture Diagram
![Architecture Diagram](https://cloud.githubusercontent.com/assets/13400667/25413414/2e5c90fc-29f8-11e7-88ee-c5301b6e132a.png)    
  We created procedures that search a given directory for .mp3 files, from there we parsed the ID3 tags and generated a list. Once this list is generated, it is displayed in the UI and the song can be controlled through the UI using data abstration into the procedures that we created to manipulate the files. The only thing that the user can see is the UI.
  
## Schedule


### First Milestone (Sun Apr 9)

We were able to get the directory path for parsing for mp3 files and MP3 ID3 parsing of object data. This milestone was met on time but there trouble with using the ```binary-class/mp3``` library on a Mac, thus I (```Mayur Khatri```) had to switch to a Windows PC to get it to work.

### Second Milestone (Sun Apr 16)

We made the UI for the player with play/pause controls that was clean and easy to use. This milestone took a bit longer and we were behind because using the ```racket/base/gui``` library proved to be more difficult than anticipated, however working together we were able to get the buttons for play/pause/shuffle to display in the correct areas of the UI as well as figuring out how to increase playlist size so that the user can easily see the playlist rather than have it be a blocky content offscreen.

### Public Presentation (Fri Apr 28)

We successfully completed getting id3 object data and parsing it to use with UI. We also were successfully able to get and play MP3 files with VLC player in the background. We were able to complete all milestones and have a finished project, in the future we may plan to add more features such as queuing up specific songs to play next like in iTunes. 

## Group Responsibilities

### Mayur Khatri @tensai66
Mayur was responsible for getting directory and file path for mp3 id3 parsing, this included the recursive functions to get list of id3 objects and parsing that data with filters to be used for the UI portion. 

The UI Portion included modifying panels for the list of songs from file directory to show song data (Working with Ryan Delosh to get the lists to properly show in the frame).

### Ryan Delosh @Liqueseous
- [ ] Milestone One - Add procedures for music manipulation that will later play a major role in UI development
- [ ] Milestone Two - Add UI components for previously mentioned procedures
- [ ] Public Presentation - Implement Extra UI feature through collabarative effort
