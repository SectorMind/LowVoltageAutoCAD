(defun create-block-table ()
  (setq blklist '("APS" "SS" "VD" "OS")) ; List of attribute values to match

  (setq tbl (vla-addtable (vla-get-activedocument (vlax-get-acad-object)) (vlax-3d-point '(0 0 0)) 3 4))
  (vla-set-rowcount tbl (+ 1 (length blklist))) ; Create a table with rows for each attribute value

  (vla-settext tbl 0 0 "Graphic Designation")
  (vla-settext tbl 0 1 "Brand")
  (vla-settext tbl 0 2 "Name")

  (setq rownum 1)
  (foreach blkval blklist
    (setq ents (entget (car (entsel))))
    (setq attlist (vl-remove-if-not '(lambda (x) (= (cdr (assoc 0 x)) 'ATTRIB))
                                     (cdr (assoc -1 ents))))
    (setq attr-values (mapcar '(lambda (att) (cdr (assoc 1 att))) attlist))
    (if (member "cjmmint" attr-values)
      (progn
        (setq attr-condition (nth (+ 1 (position "commint" attr-values)) attr-values))
        (if (member attr-condition blklist)
          (progn
            (setq attr-brand (nth (+ 1 (position "brand" attr-values)) attr-values))
            (setq attr-name (nth (+ 1 (position "name" attr-values)) attr-values))
            (vla-settext tbl rownum 0 attr-condition)
            (vla-settext tbl rownum 1 attr-brand)
            (vla-settext tbl rownum 2 attr-name)
            (setq rownum (+ rownum 1))
          )
        )
      )
    )
  )
)

(create-block-table)