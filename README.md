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
![Architecture Diagram](https://cloud.githubusercontent.com/assets/16441327/24590864/f4334e3a-17c2-11e7-9328-5012de00fdb9.png)
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

### Ryan Delosh @Liqueseous
- [ ] Milestone One - Add procedures for music manipulation that will later play a major role in UI development
- [ ] Milestone Two - Add UI components for previously mentioned procedures and create unit tests for data parsing
- [ ] Public Presentation - Implement Extra UI feature through collabarative effort
