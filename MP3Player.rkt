#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;Developed by
;;;;Ryan DeLosh - @Liqueseous
;;;;Mayur Khatri - @Tensai66
;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require vlc)
(require racket/file)
(require binary-class/mp3)
(require racket/gui/base)

(define my-vlc (start-vlc #:port 5000 #:hostname "127.0.0.1"))
(vlc-loop #t)
(define nil '())

;;;;;;;;;;CHANGE BELOW PATH TO YOUR MEDIA FILE PATH;;;;;;;;;;;;;;;;
;;(define file-path (string->path "C:\\Users\\MayursMac\\Music\\My Music\\Blink 182 Discography\\2013 - Icon\\"))
(define file-path (string->path "/Users/liqueseous/ownCloud/Documents/Repos/MP3-Player/TestMedia/"))
;;;;;;;;;;;;;;;;;;;;;;CHANGE ABOVE PATH;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (file-format exten) (string-suffix? (path->string exten) ".mp3"))
(define file-folder (find-files file-format file-path))


(define (make-list file-folder)
  (if (null? file-folder)
      '()
      (cons (path->string (car file-folder)) (make-list (cdr file-folder)))))

(define (get-song get-song-dir)
  (if (null? get-song-dir)
      '()
      (cons (if (eq? (song (read-id3 (car get-song-dir))) #f)
                "No Title Available"
                (song (read-id3 (car get-song-dir))))
            (get-song (cdr get-song-dir)))))

(define (get-artist get-song-dir)
  (if (null? get-song-dir)
      '()
      (cons (if (eq? (artist (read-id3 (car get-song-dir))) #f)
                "No Artist Available"
                (artist (read-id3 (car get-song-dir))))
            (get-song (cdr get-song-dir)))))

(define artist-list (get-artist file-folder))
(define title-list (get-song file-folder))

(define get-song-dir (make-list file-folder)) ;;function to put songs into list from the file-path
;Creates a state object that we can later use to keep track of true/false states
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
  
  (define (dispatch m)
            (cond ((eq? m 'flip) (change-state))
                  ((eq? m 'false) (setF))
                  ((eq? m 'true) (setT))
                  ((eq? m 'state?) (getState))
                  (else (error "Unknown request" m))))
  dispatch)
;;interface with state using
;;(statename 'flip) toggle between true/false
;;(statename 'false) set that state to false
;;(statename 'true) set that state to true
;;(statename 'state?) retrive the value of the state

;Define of our states
(define isShuffle (make-state #f))
(define isPlaying (make-state #f))

;;Play Now
;;;Must be able to adapt to every song will add to top of queue and play now depending on what vlc supports
(define (playNow URL)
  (begin (clearQ)
  (addQ URL)
  (sleep .05)
  (myplay)))


;;Song Pause/unpause
;pause should only be used to pause, not initiate playback, play should be used to resume
;play-pause is the safest way to handle this
(define (pause) (begin (isPlaying 'flip) (vlc-pause)))

;;Play in queue
(define (myplay) (begin (vlc-play) (isPlaying 'true)))
;;Stop Song
(define (mystop) (begin (vlc-stop) (isPlaying 'false)))
;;toggle play/pause
(define (myplay-pause) (if (eq? #f (isPlaying 'state?))
                         (begin (isPlaying 'true) (myplay))
                         (begin (pause))))
;;Song Next in Queue
(define (myNext) (if (eq? #f (isPlaying 'state?))
                              (begin (vlc-next) (vlc-seek 0) (sleep .1) (vlc-pause) (send PlayMsg set-label (string-append "Paused - " (getTitle))))
                              (begin (vlc-next) (vlc-seek 0) (sleep .1)(isPlaying 'true) (send PlayMsg set-label (string-append "Playing - " (getTitle))))))
;;Song Previous
(define (myPrev) (if (eq? #f (isPlaying 'state?))
                              (begin (vlc-prev) (vlc-seek 0) (sleep .1) (vlc-pause) (send PlayMsg set-label (string-append "Paused - " (getTitle))))
                              (begin (vlc-prev) (vlc-seek 0) (sleep .1) (isPlaying 'true) (send PlayMsg set-label (string-append "Playing - " (getTitle))))))

;;get title
(define (getTitle) (vlc-get-title))
;;currentlyPlaying?
(define (isPlaying?) (isPlaying 'state?))

;;Shuffle All
(define (shuffleAll lst)
  (begin (playAll lst)
   (shuffleToggle)))

;;Toggle shuffle playback
(define (shuffleToggle)
  (if (eq? isShuffle #t)
       (begin (vlc-random #f) (isShuffle 'false))
       (begin (vlc-random #t) (isShuffle 'true))))

;;Play All
;;;Adds all to queue without shuffling
(define (playAll lst)
  (if (eq? lst nil)
      'ok
      (begin(addQ (car lst))(isPlaying 'true)(playAll (cdr lst)))))
;;Add to Queue
;;;Must be able to adapt to every song
(define (addQ URL) (if (eq? #f (isPlaying 'state?))
                              (begin (vlc-add URL) (vlc-seek 0) (mystop))
                              (begin (vlc-add URL) (vlc-seek 0) (isPlaying 'true))))
                                     
;;Clear Queue
(define (clearQ) (begin (vlc-clear) (isPlaying 'false)))
;;;USED FOR LOCAL TESTING
;;/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Hypnotic.mp3
;;(define mylist '("/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/NEST.mp3""/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Victorious.mp3""/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Hypnotic.mp3"))



(define window (new frame% [label "MP3-Player"]
                    [width 500]
                    [height 600]))
(define topleft (new horizontal-panel%
                     [parent window]
                     [alignment '(center top)]
                     [spacing 5]
                     [border 0]
                     [vert-margin 0]
                     [horiz-margin 100]))
(define song-panel (new vertical-panel%
                      [parent window]
                      [alignment '(center center)]
                      [vert-margin 0]
                      [min-height 600]
                      [style '(auto-vscroll)]))
(define statuspanel (new panel%
                         [parent window]
                         [alignment '(center bottom)]
                         [vert-margin 0]
                         [spacing 0]
                         [border 0]))
(define bottom (new horizontal-panel%
                    [parent window]
                    [alignment '(center top)]
                    [vert-margin 0]
                    [horiz-margin 0]
                    [spacing 5]
                    [border 0]))

;;print list of songs
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

(define printed-songs (print-songs title-list artist-list get-song-dir))


;;current song status
(define PlayMsg (new message% [parent statuspanel]
                     [label "Not Playing"]
                     [auto-resize #t]))
;;previous song button
(new button% [parent bottom] [label "<<"]
     [callback (lambda (button event)
                 (begin (myPrev)))])

;;pause/play button
(define pp (new button% [parent bottom] [label "Play"]
     [callback (lambda (button event)
                 (begin (sleep .01) (if (eq? (isPlaying 'state?) #f)
                                        (begin (send pp set-label "Pause")
                                               (sleep .5)
                                               (send PlayMsg set-label (string-append "Playing - " (getTitle))))
                                        (begin (send pp set-label "Play")
                                               (sleep .5)
                                               (send PlayMsg set-label (string-append "Paused - " (getTitle)))))
                        (myplay-pause)))]))
;;next song button
(new button% [parent bottom] [label ">>"]
     [callback (lambda (button event)
                 (myNext))])


;;clear queue button
(define clearQB (new button% [parent topleft] [label "Clear Queue"]
     [callback (lambda (button event)
                 (begin (clearQ)
                        (send pp set-label "Play")
                        (send PlayMsg set-label "Cleared Queue")
                        (sleep 1)
                        (send PlayMsg set-label "Not Playing")))]))

;;play all songs button
(define playallB (new button% [parent topleft] [label "Play All"]
     [callback (lambda (button event)
                 (begin (playAll get-song-dir)
                        (send pp set-label "Pause")
                        (sleep .5)
                        (send PlayMsg set-label (string-append "Playing - " (getTitle)))))]))

;;shuffle all songs button
(define shuffleallB (new button% [parent topleft] [label "Shuffle All"]
     [callback (lambda (button event)
                 (begin (shuffleAll get-song-dir)
                        (send pp set-label "Pause")
                        (send shuffleTB set-label "Shuffle On")
                        (sleep .5)
                        (send PlayMsg set-label (string-append "Playing - " (getTitle)))))]))

;;shuffle toggle button
(define shuffleTB (new button% [parent topleft] [label "Shuffle Off"]
     [callback (lambda (button event)
                 (begin (sleep .01) (if (eq? (isShuffle 'state?) #f)
                                        (begin (send shuffleTB set-label "Shuffle On")
                                               (isShuffle 'true)
                                               (vlc-random #t))
                                        (begin (send pp set-label "Play")
                                               (begin (send shuffleTB set-label "Shuffle Off")
                                               (isShuffle 'false)
                                               (vlc-random #f))))))]))


(send window show #t)
