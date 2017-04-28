# MP3 Player in Racket

## Mayur Khatri
### April 28, 2017

# Overview
This project provides a way to play MP3 songs in Racket with an easy to use UI. 
The most important feature is that it allows the users to add as many songs as they'd like to the list but also shuffle them so as to not keep playing in a repetitive order. 

The program will recursively look through any given directory that contains files and then look for any files with the extension ".mp3", and place them into a list that will be processed recursively to extract ID3 object data. 

This ID3 object data will again be processed recursively to filter out only the artist and the song name that will be used in the UI so that users may see which songs are in the playlist in the format "artist - song". 

The program follows the main aspects of functional programming. It has data abstraction, recursion to filter data, state modification, and objection orientation used throughout.

**Authorship note:** The code explained here is written by both my partner and I.

# Libraries Used
The code uses four libraries:

```
(require vlc)
(require racket/file)
(require binary-class/mp3)
(require racket/gui/base)
```

* The ```vlc``` library provides the ability to play media files in Racket, specifically MP3. 
* The ```racket/file``` library is used to search through the system directory and get files. 
* The ```binary-class/mp3``` library is used to obtain ID3 object data and parse the data that is contained within the MP3 files. 
* The ```racket/gui/base``` library is used for the UI of the MP3 Player, having shuffle/play/pause ability and displaying song playlist. 

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Five examples are shown and they are individually numbered. 

## 1. Data Abstraction for Program States
```
This part was worked on by my partner Ryan Delosh.
```
The following code creates a procedure, ```dispatch``` that is used to set the states of controls in the program such as play/pause/shuffle. 

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

 This code is very similar to the ```make-account``` procedure. There are constructors and selectors for creating the data structures and retrieving their values. Thus, the abstraction barrier is never broken because the contents of the data object aren't directly accessed.
 
## 2. Using Recursion to Process Object Data
```
This part was worked on by me.
```

A set of procedures was created to operate on the main ```read-id3``` interface object. 

The procedure ```make-list``` was created to traverse through all the files which were retrieved by ```file-path``` that had the extension ".mp3" from ```file-format``` and then to make a list of these.
```
(define (make-list file-folder)
  (if (null? file-folder)
      '()
      (cons (path->string (car file-folder)) (make-list (cdr file-folder)))))
```

The procedure ```get-song``` is used to retrieve the songs from the ```read-id3``` interface object. It's given ```get-song-dir``` which uses the ```make-list``` procedure from before to get the song names and place them into a list.

```
(define get-song-dir (make-list file-folder))
```

```
(define (get-song get-song-dir)
  (if (null? get-song-dir)
      '()
      (cons (if (eq? (song (read-id3 (car get-song-dir))) #f)
                "No Title Available"
                (song (read-id3 (car get-song-dir))))
            (get-song (cdr get-song-dir)))))
```
The procedure ```get-artist``` is used to retrieve the artist from the ```read-id3``` interface object. It's also given ```get-song-dir``` which uses the ```make-list``` procedure from before to get the artist names and place them into a list as well. Thus, giving the artist and the song which will be used later for the UI playlist.

```
(define (get-artist get-song-dir)
  (if (null? get-song-dir)
      '()
      (cons (if (eq? (artist (read-id3 (car get-song-dir))) #f)
                "No Artist Available"
                (artist (read-id3 (car get-song-dir))))
            (get-song (cdr get-song-dir)))))
```

## 3. Functional Approach to Processing Data
```
This part was worked on by me.
```
The following procedures ```file-format```, ```file-path```, and ```file-folder``` are created to find the files to be used for reading the object data. 

```
(define file-path (string->path "PATH_TO_FOLDER_WITH_SONGS"))
(define (file-format exten) (string-suffix? (path->string exten) ".mp3"))
(define file-folder (find-files file-format file-path))
```

Then the above procedures are used with the functional programming approach; the abstraction barrier is not broken and then the below procedures are used with the procedures listed in section 2 to obtain the information needed to process the ```read-id3``` object. 

```
(define artist-list (get-artist file-folder))
(define title-list (get-song file-folder))
(define get-song-dir (make-list file-folder))
```

This procedure here uses ```get-song-dir``` and recurses through to get the song name using the functional programming approach to processing data first getting the car of the ```read-id3``` object and then calling unto itself and getting the cdr of the list. 
```
(define (get-song get-song-dir)
  (if (null? get-song-dir)
      '()
      (cons (if (eq? (song (read-id3 (car get-song-dir))) #f)
                "No Title Available"
                (song (read-id3 (car get-song-dir))))
            (get-song (cdr get-song-dir)))))
```

## 4. State-Modification Approach to Changing Program State
```
This part was worked on by my partner Ryan Delosh.
```
The program states where changed by first creating a ```Statenow``` object so that it was encapsulated, which was then modified for either ```#t``` or ```#f``` based upon whether the shuffle was on/off or the song was paused/playing. 

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
