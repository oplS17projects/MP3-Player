#lang racket

(require racket/file)
(require binary-class/mp3)

(define file-path (string->path "C:\\Users\\MayursMac\\Music\\My Music\\Blink 182 Discography\\2013 - Icon\\"))
(define (file-format exten) (string-suffix? (path->string exten) ".mp3"))
(define file-folder (find-files file-format file-path))
(define get-song-info '())

(define (list-of-songs get-song-info)
  (if (null? get-song-info)
      '()
      (cons (string-append (song (car get-song-info))))))