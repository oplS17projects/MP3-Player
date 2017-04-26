# MP3-Player

### Statement
An MP3 Player in Racket with clean UI. It's interesting because it takes most of the core concepts learned in class like recursion, filter and object orientation.

### Analysis

Data abstraction by the ID3 tags as objects from structure.  
Recursively making list of ID3 objects for album/artists.  
Filtering ID3 objects by the album/artists and outputting.  
Functional approaches by recursively processing the album/artists then outputting.  

### External Technologies

The project processes sound by using VLC player with an interactive interface (play/pause controls etc).

### Data Sets or other Source Materials

Source materials include MP3 files on the system which will be played. Since the files are played in MP3 format which is only supported by VLC.

### Deliverable and Demonstration

An MP3 player that has a clean interactive UI allowing for control over the player such as pause/play.

### Evaluation of Results

If all criteria for the project are met (analysis section).    
If the player is able to open and play the files successfully and has an interactive UI.  

## Architecture Diagram
![Architecture Diagram](https://cloud.githubusercontent.com/assets/13400667/25413414/2e5c90fc-29f8-11e7-88ee-c5301b6e132a.png)    
  We will create a procedure that will search a given directory for .mp3 files, from there we will parse the ID3 tags and generate a list. Once the list is generated it is displayed in the UI and the song can be controlled through the UI using data abstration into the procedures that we created to manipulate the files. The only thing that the user can see is the UI.
  
## Schedule


### First Milestone (Sun Apr 9)

Directory path for parsing for mp3 files and MP3 ID3 parsing of object data.  

### Second Milestone (Sun Apr 16)

Making the UI for the player with play/pause controls that is clean and easy to use.  

### Public Presentation (Fri Apr 28)

Successfully have completed getting id3 object data and parsing it to use with UI, getting and playing MP3 files with VLC player in the background.

## Group Responsibilities

### Mayur Khatri @tensai66
Getting directory and file path for mp3 id3 parsing, this includes the recursive functions to get list of id3 objects and parsing that data with filters to be used for the UI portion. 

UI Portion includes modifying panels for the list of songs from file directory to show song data (Working with Ryan Delosh to get the lists to properly show in the frame).

### Ryan Delosh @Liqueseous
- [ ] Milestone One - Add procedures for music manipulation that will later play a major role in UI development
- [ ] Milestone Two - Add UI components for previously mentioned procedures
- [ ] Public Presentation - Implement Extra UI feature through collabarative effort
