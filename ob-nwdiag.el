;;; ob-blockdiag.el --- org-babel functions for blockdiag evaluation

;; Copyright (C) 2017 Dmitry Moskowski

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Author: Dmitry Moskowski
;; Keywords: tools, convenience
;; Package-Version: 20170501.112
;; Homepage: https://github.com/baron/ob-nwdiag.el

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; Org-Babel support for evaluating nwdiag source code.

;;; Requirements:

;; - nwdiag :: http://nwdiag.com/en/

;;; Code:
(require 'ob)

(defvar org-babel-default-header-args:nwdiag
  '(
    (:results . "file")
    (:exports . "results")
    (:tool    . "nwdiag")
    (:font    . nil)
    (:size    . nil))
  "Default arguments for drawing a nwdiag image.")

(add-to-list 'org-src-lang-modes '("nwdiag" . nwdiag))

(defun org-babel-execute:nwdiag (body params)
  (let ((file (cdr (assoc :file params)))
        (tool (cdr (assoc :tool params)))
        (font (cdr (assoc :font params)))
        (size (cdr (assoc :size params)))

        (buffer-name "*ob-nwdiag*")
        (error-template "Subprocess '%s' exited with code '%d', see output in '%s' buffer"))
    (save-window-excursion
      (let ((buffer (get-buffer buffer-name)))(if buffer (kill-buffer buffer-name) nil))
      (let ((data-file (org-babel-temp-file "nwdiag-input"))
            (args (append (list "-o" file)
                          (if size (list "--size" size) (list))
                          (if font (list "--font" font) (list))))
            (buffer (get-buffer-create buffer-name)))
        (with-temp-file data-file (insert body))
        (let
            ((exit-code (apply 'call-process tool nil buffer nil (append args (list data-file)))))
          (if (= 0 exit-code) nil (error (format error-template tool exit-code buffer-name))))))))

(provide 'ob-nwdiag)
;;; ob-nwdiag.el ends here
