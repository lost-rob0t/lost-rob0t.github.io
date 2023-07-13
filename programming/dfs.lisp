(ql:quickload :alexandria)
(ql:quickload :serapeum)
(in-package :cl-user)
(uiop:define-package :name of package
                     (:use :cl))



(setq graph (serapeum:dict "a" '("b" "c") "b" '("d" "f") "c" '("e") "d" '("f") "e" nil "f" nil))

(defun depth-first-print (graph source)
  (let ((stack (make-array 10 :element-type 'string)))
    (push source stack)
    (loop while stack
          for current = (pop stack)
          do (loop for neighbor in (gethash current graph)
                   do (push neighbor stack))

          do (format t "Current: ~a~%" current))))
(defun depth-first-print* (graph source)

    (format t "Current: ~a~%" source)
  (loop for neighbor in (serapeum:href graph source)

        do (depth-first* graph neighbor)))



(defun dfs-has-path-p (graph source dest &key (test #'equalp))
  (let ((stack (make-array 10 :element-type 'string)))
    (push source stack)
    (loop while stack
          for current = (pop stack)
          do (if (funcall test current dest)
                 (return t))
          do (loop for neighbor in (gethash current graph)
                   do (push neighbor stack))

          do (format t "Current: ~a~%" current))))


(depth-first-print* graph "b")
