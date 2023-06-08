(ql:quickload :alexandria)
(ql:quickload :serapeum)

(setq graph (serapeum:dict "a" '("b" "c") "b" '("d") "c" '("e") "d" '("f") "e" '("g" "f") "f" nil "g" nil))


(defun breadth-first (graph source)
  (let ((queue (serapeum:queue source)))
    (loop while queue
          for current = (serapeum:deq queue)
          do (if (null current)
                 (return nil))
          do (loop for neighbor in (gethash current graph)
                   do (serapeum:enq neighbor queue))

          do (format t "Current: ~a~%" current))))
(breadth-first graph "a")
