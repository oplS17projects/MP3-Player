# MP3 Player in Racket

## Mayur Khatri
### April 28, 2017

# Overview
This project provides a way to play MP3 songs in Racket with an easy to use UI. 
The most important feature is that it allows the users to add as many songs as they'd like to the list but also shuffle them so as to not keep playing in a repetitive order. 

The program will recursively look through any given directory that contains files and then look for any files with the extension ".mp3", and place them into a list that will be processed recursively to extract ID3 object data. 

This ID3 object data will again be processed recursively to filter out only the artist and the song name that will be used in the UI so that users may see which songs are in the playlist in the format "artist - song". 

**Authorship note:** All of the code described here was written by myself.

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

## 3. Using Recursion to Accumulate Results

The low-level routine for interacting with Google Drive is named ```list-children```. This accepts an ID of a 
folder object, and optionally, a token for which page of results to produce.

A lot of the work here has to do with pagination. Because it's a web interface, one can only obtain a page of
results at a time. So it's necessary to step through each page. When a page is returned, it includes a token
for getting the next page. The ```list-children``` just gets one page:

```
(define (list-children folder-id . next-page-token)
  (read-json
   (get-pure-port
    (string->url (string-append "https://www.googleapis.com/drive/v3/files?"
                                "q='" folder-id "'+in+parents"
                                "&key=" (send drive-client get-id)
                                (if (= 1 (length next-page-token))
                                    (string-append "&pageToken=" (car next-page-token))
                                    "")
;                                "&pageSize=5"
                                ))
    token)))
```
The interesting routine is ```list-all-children```. This routine is directly invoked by the user.
It optionally accepts a page token; when it's used at top level this parameter will be null.

The routine uses ```let*``` to retrieve one page of results (using the above ```list-children``` procedure)
and also possibly obtain a token for the next page.

If there is a need to get more pages, the routine uses ```append``` to pre-pend the current results with 
a recursive call to get the next page (and possibly more pages).

Ultimately, when there are no more pages to be had, the routine terminates and returns the current page. 

This then generates a recursive process from the recursive definition.

```
(define (list-all-children folder-id . next-page-token)
  (let* ((this-page (if (= 0 (length next-page-token))
                      (list-children folder-id)
                      (list-children folder-id (car next-page-token))))
         (page-token (hash-ref this-page 'nextPageToken #f)))
    (if page-token
        (append (get-files this-page)
              (list-all-children folder-id page-token))
        (get-files this-page))))
```

## 4. Filtering a List of File Objects for Only Those of Folder Type

The ```list-all-children``` procedure creates a list of all objects contained within a given folder.
These objects include the files themselves and other folders.

The ```filter``` abstraction is then used with the ```folder?``` predicate to make a list of subfolders
contained in a given folder:

```
(define (list-folders folder-id)
  (filter folder? (list-all-children folder-id)))
```

## 5. Recursive Descent on a Folder Hierarchy

These procedures are used together in ```list-all-folders```, which accepts a folder ID and recursively
obtains the folders at the current level and then recursively calls itself to descend completely into the folder
hierarchy.

```map``` and ```flatten``` are used to accomplish the recursive descent:

```
(define (list-all-folders folder-id)
  (let ((this-level (list-folders folder-id)))
    (begin
      (display (length this-level)) (display "... ")
      (append this-level
              (flatten (map list-all-folders (map get-id this-level)))))))
```
