# MP3 Player in Racket

## Ryan DeLosh
### April 29, 2017

# Overview
This project provides a way to play MP3 songs in Racket with an easy to use UI. 
Some important features this program provides is the ability for user to play MP3 files within racket.

The program will recursively look through any given directory that contains files and look for any files with the extension ".mp3", from there it will generate a list of URL's and will make a list of ID3 objects that will be processed recursively to extract ID3 object data. 

From these URL's we can manipulate the songs through our getters and setters we created for data abstraction. 

The ID3 object data is used to display to the user the information about any given song.
This data is then processed recursively to filter out only the artist and the song name that is used in the UI so that users may see which songs are in the playlist in the format "artist - song". 

The program follows the main aspects of functional programming. It has data abstraction, recursion to filter data, state modification, and object orientation used throughout.

**Authorship note:** The code explained here is written by both my partner and I.

# Libraries Used
The code uses four libraries:

```
(require vlc)
(require racket/file)
(require binary-class/mp3)
(require racket/gui/base)
```

* The ```vlc``` library givrd the ability to play media files in Racket, specifically MP3 as racket does not natively support MP3 file playback.
* The ```racket/file``` library is used to search through the system directory and retrieve the files within it. 
* The ```binary-class/mp3``` library is used to obtain ID3 object data and parse the data that is contained within the MP3 files. 
* The ```racket/gui/base``` library is used for the UI of the MP3 Player, having shuffle/play/pause ability and displaying song playlist. 

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Four examples are shown and they are individually numbered. 

## 1. Selectors using Procesural Abstraction
```
This part was worked on by me.
```
The following code creates a procedure, ```playNow``` that is used to play a given song right away.
```
(define (playNow URL)
  (begin (clearQ)
  (addQ URL)
  (sleep .05)
  (myplay)))
```
This procedure runs other procedures that I creates as setters to provide data abstraction. Below are the setters that this procedure calls.
```
(define (clearQ) (begin (vlc-clear) (isPlaying 'false)))

(define (addQ URL) (if (eq? #f (isPlaying 'state?))
                              (begin (vlc-add URL) (vlc-seek 0) (mystop))
                              (begin (vlc-add URL) (vlc-seek 0) (isPlaying 'true))))
                                     
;;Clear Queue

(define (myplay) (begin (vlc-play) (isPlaying 'true)))
```
 There are many more procedures within the program that demonstrate procedural abstraction.
 
## 2. Using Recursion
```
This part was worked on by me and my partner Mayur.
```

A set of procedures was created to display songs to the user to interact with.

The procedure ```print-songs``` was created to recursively print out a list of songs along with a play button for that song.
```
(define (print-songs songs artists songdir)
  (if (null? songs)
      '()
      (begin (new message% [parent song-panel]
                           [label (string-append (car songs) " - " (car artists))])

             (new button% [parent song-panel] [label "Play Now"]
     [callback (lambda (button event)
                 (begin (playNow (car songdir))
                        (send pp set-label "Pause")
                        (send PlayMsg set-label (string-append "Playing - " (getTitle)))))])
             
             (print-songs (cdr songs) (cdr artists) (cdr songdir)))))
```

The procedure ```printed-songs``` is used as a helper function that starts the recursive printing of the songs providing another later of data abstraction.
```
(define printed-songs (print-songs title-list artist-list get-song-dir))
```
## 3. State-Modification Approach to Changing Program States
```
This part was worked on by me..
```
The program uses states to keep track of different things going on. Mainly play/pause and shuffle. These states are provided an initialized value provided within ```Statenow```  this state is then then modified for either ```#t``` or ```#f``` based upon whether the shuffle was on/off or the song was paused/playing. 

```
(define (make-state Statenow)

  (define (change-state)
    (if (eq? Statenow #f)
        (set! Statenow #t)
        (set! Statenow #f)))

  (define (setF)
    (set! Statenow #f))

  (define (setT)
    (set! Statenow #t))
```


## 4. Data Abstraction for Program States
```
This part was worked on by me.
```
The following code creates a procedure, ```dispatch``` that is used to set the states of controls in the program such as whether a song is playing or if the program is set to shuffle the songs. 

```
  (define (dispatch m)
            (cond ((eq? m 'flip) (change-state))
                  ((eq? m 'false) (setF))
                  ((eq? m 'true) (setT))
                  ((eq? m 'state?) (getState))
                  (else (error "Unknown request" m))))
 ```
 Below are the constructors and selectors for the procedure ```dispatch```. 
 
 ```
(define (make-state Statenow)

  (define (change-state)
    (if (eq? Statenow #f)
        (set! Statenow #t)
        (set! Statenow #f)))

  (define (setF)
    (set! Statenow #f))

  (define (setT)
    (set! Statenow #t))
  
  (define (getState) Statenow)
```

 This code is very similar to the ```make-account``` procedure. There are constructors and selectors for creating the data structures and retrieving their values. Thus, the abstraction barrier is never broken because the contents of the data object aren't directly accessed by the user.
