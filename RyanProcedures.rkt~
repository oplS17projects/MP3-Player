#lang racket/gui
(require vlc)
(require racket/gui/base)

(define my-vlc (start-vlc #:port 5000 #:hostname "127.0.0.1"))
(vlc-loop #t)
(define nil '())

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
  (addQ URL)))


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
(define (myNext) (vlc-next))
;;Song Previous
(define (myPrev) (vlc-prev))
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
                              (begin (vlc-add URL) (mystop))
                              (begin (vlc-add URL) (isPlaying 'true))))
                                     
;;Clear Queue
(define (clearQ) (begin (vlc-clear) (isPlaying 'false)))
;;;USED FOR LOCAL TESTING
;;/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Hypnotic.mp3
;;(define mylist '("/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/NEST.mp3""/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Victorious.mp3""/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Hypnotic.mp3"))



(define window (new frame% [label "MP3-Player"]))
(define bottom (new horizontal-panel% [parent window] [alignment '(center bottom)]))

;;(define msg (new message% [parent bottom]
;;                 [label "No events so far..."]))

(define dialog (instantiate dialog% ("Example")))
(new text-field% [parent dialog] [label "Your name"])

(define pp (new button% [parent bottom] [label "Play"]
     [callback (lambda (button event)
                 (begin (sleep .01) (if (eq? (isPlaying 'state?) #f)
                                        (send pp set-label "Pause")
                                        (send pp set-label "Play"))
                        (myplay-pause)))]))

(when (system-position-ok-before-cancel?)
  (send bottom change-children reverse))

;;(new button% [parent bottom]
;;     [label "Click Me"]
;;     [callback (lambda (button event)
;;                 (send msg set-label "Button Clicked"))])
;;addQ "/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/TestMedia/Hypnotic.mp3"

(send window show #t)
















