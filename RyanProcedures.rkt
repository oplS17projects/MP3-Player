#lang racket
(require vlc)

(define my-vlc (start-vlc #:port 5000 #:hostname "127.0.0.1"))
(vlc-loop #t)
(define isShuffle #f)
(define isPlaying #f)
(define nil '())
;;Play Now
;;;Must be able to adapt to every song will add to top of queue and play now depending on what vlc supports
(define (playNow URL)
  (begin (clearQ)
  (addQ URL)))

;;Song Pause/unpause
(define (pause) (begin (vlc-pause)
                 (if (eq? isPlaying #t)
                     (set! isPlaying #f)
                     (set! isPlaying #t))))

;;Song Next in Queue
(define (myNext) (vlc-next))
;;Song Previous
(define (myPrev) (vlc-prev))
;;currentlyPlaying?
(define (isPlaying?) isPlaying)

;;Shuffle All
(define (shuffleAll lst)
  (begin (playAll lst)
   (shuffleToggle)))

(define (shuffleToggle)
  (if (eq? isShuffle #t)
       (begin (vlc-random #f) (set! isShuffle #f))
       (begin (vlc-random #t) (set! isShuffle #t))))
;;Play All
;;;Adds all to queue without shuffling
(define (playAll lst)
  (if (eq? lst nil)
      'ok
      (begin(addQ (car lst))(set! isPlaying #t)(playAll (cdr lst)))))
;;Add to Queue
;;;Must be able to adapt to every song
(define (addQ URL) (begin (vlc-add URL)
                    (set! isPlaying #t)))
;;Clear Queue
(define (clearQ) (vlc-clear))
;;/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/Media/Hypnotic.mp3
;;(define mylist '("/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/Media/NEST.mp3""/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/Media/Victorious.mp3""/Users/liqueseous/ownCloud/Documents/Spring2017/OPL/MP3-Player/Media/Hypnotic.mp3"))




















