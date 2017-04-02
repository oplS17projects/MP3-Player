# MP3-Player

### Statement
An MP3 Player in Racket with clean UI. It's interesting because it takes most of the core concepts learned in class like recursion, filter and object orientation.

### Analysis

Data abstraction by the ID3 tags as objects from structure.  
Recursively making list of ID3 objects for album/artists.  
Filtering ID3 objects by the album/artists and outputting.  
Object orientation by ID3 objects that have functions for returning songs/albums/artists/year/genre.  
Functional approaches by recursively processing the album/artists then outputting.  

### External Technologies

Project will process sound by using VLC player with an interactive interface (play/pause controls etc).

### Data Sets or other Source Materials

Source materials include MP3 files on the system which will be played. Since the files will be in MP3 format or any format supported by VLC.

### Deliverable and Demonstration

An MP3 player that has an clean interactive UI allowing for control over the player such as pause/play.

### Evaluation of Results

If all criteria for the project are met (analysis section).    
If the player is able to open and play the files successfully and has a clean interactive UI.  

## Architecture Diagram
Upload the architecture diagram you made for your slide presentation to your repository, and include it in-line here.

Create several paragraphs of narrative to explain the pieces and how they interoperate.

## Schedule
Explain how you will go from proposal to finished product. 

There are three deliverable milestones to explicitly define, below.

The nature of deliverables depend on your project, but may include things like processed data ready for import, core algorithms implemented, interface design prototyped, etc. 

You will be expected to turn in code, documentation, and data (as appropriate) at each of these stages.

Write concrete steps for your schedule to move from concept to working system. 

### First Milestone (Sun Apr 9)

Directory path for files and MP3 ID3 parsing of data.  

### Second Milestone (Sun Apr 16)

UI for music player.  

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28 [your date to be determined later])

Extra UI features (open custom files).  


## Group Responsibilities
Here each group member gets a section where they, as an individual, detail what they are responsible for in this project. Each group member writes their own Responsibility section. Include the milestones and final deliverable.

Please use Github properly: each individual must make the edits to this file representing their own section of work.


### Mayur Khatri @tensai66
mp3 id3 parsing 

### Ryan Delosh @Liqueseous
Milestone One - Add procedures for music manipulation that will later play a major role in UI development
Milestone Two - Add UI components for previously mentioned procedures and create unit tests for data parsing features
Public Presentation - Implement Extra UI feature through collabarative effort
