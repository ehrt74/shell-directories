;; -*- lexical-binding: t; -*-
(setq lexical-binding t)

(defun sd--alist-with (al key val)
  (named-let foo ((al al) (ret '()) (found nil))
    (if (null al)
	(if found
	    (reverse ret)
	  (reverse (cons (cons key val) ret)))
      (cl-destructuring-bind (k . v) (car al)
	(if (equal k key)
	    (foo (cdr al) (cons (cons k val) ret) t)
	  (foo (cdr al) (cons (car al) ret) nil))))))

(defun sd--to-alist ( &rest vals)
  (named-let foo ((vals vals) (ret '()))
    (if (null vals)
	(reverse ret)
      (cl-destructuring-bind (a1 a2 . r) vals
	(foo r (cons (cons a1 a2) ret))))))


(defgroup bashmarks nil "agordoj por bashmarks")

(defcustom bashmark-path "~/.cd.db" "dosierindiko de la datumbazo" :type '(string) :group 'bashmarks)

(defun sd--calculate-index (paths index)
  (let* ((len (length paths))
	 (first-empty-index (seq-position paths :null)))
    (cond
     (first-empty-index first-empty-index)
     ((< len 10) -1)
     (t (% (1+ index) 10)))))

(defun sd--trim-empty-right (paths)
  (let* ((it paths)
	 (it (reverse it))
	 (it (seq-drop-while (lambda (s) (eq s :null)) it))
	 (it (reverse it)))
    it))

(defun sd--get-db () (json-read-file bashmark-path))

(defun sd--save-db (db)
  (let* ((paths (alist-get 'Paths db []))
	 (new-paths (sd--trim-empty-right paths))
	 (index (alist-get 'CurrentIndex db -1))
	 (new-index (sd--calculate-index new-paths index))
	 (db (sd--to-alist
	      'CurrentIndex new-index
	      'Paths new-paths)))
    (with-temp-file bashmark-path
      (insert (json-serialize db)))))

(defun eshell/sdd (i)
  (let* ((db (sd--get-db))
	 (paths (alist-get 'Paths db [])))
    (when (< i (length paths))
      (aset paths i :null))
    (sd--save-db (sd--alist-with db 'Paths paths))))

(defun eshell/sda ()
  (let* ((wd (eshell/pwd))
	 (db (sd--get-db))
	 (paths (alist-get 'Paths db []))
	 (index (alist-get 'CurrentIndex db -1))
	 (new-paths (if (= index -1)
			(vconcat paths (vector wd))
		      (progn
			(aset paths index wd)
			paths))))
    (sd--save-db (sd--alist-with db 'Paths new-paths))))

(defun eshell/sdg (i)
  (let ((paths (alist-get 'Paths (sd--get-db) [])))
    (when (> (length paths) i)
      (sd (elt paths i)))))

(defun eshell/sdl ()
  (let* ((db (sd--get-db))
	 (paths (alist-get 'Paths db []))
	 (index (alist-get 'CurrentIndex db -1)))
    (dotimes (i (length paths))
      (eshell-print (format "%d%s %s\n" i (if (= i index) "*" " ") (or (elt paths i) ""))))))

(defun eshell/sdc () (sd--save-db '()))

