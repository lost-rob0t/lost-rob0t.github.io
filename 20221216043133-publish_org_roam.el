(defmacro with-batch (&rest body)
  "Execute BODY only if Emacs is running in batch mode."
  `(when noninteractive
     ,@body))

(with-batch
 (progn
   (require 'package)
   (setq package-user-dir (expand-file-name "./.packages"))
   (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                            ("elpa" . "https://elpa.gnu.org/packages/")
                            ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
   (package-initialize)
   (unless package-archive-contents
     (package-refresh-contents))
   (package-install 'htmlize)
   (package-install 'org-roam)
   (package-install 'org-contrib)))
(require 'htmlize) ;; For Code blocks
(require 'find-lisp)
(require 'org)
(load-file "~/.dotfiles/lisp/org-helpers/ox-rss.el")
(require 'ox-publish)
(require 'org-roam-export) ;; Fixes for org roam to work with ox-publish
(require 'ox-rss)

(defvar project-dir "~/Documents/Notes/org/roam"
  "The Path to the Notes")
(defvar project-output-dir "~/Documents/Notes/org/public")
(if (not noninteractive)
    (setq project-dir org-roam-directory)
  (setq org-roam-directory project-dir))

(defvar banned-files "sunshine/\\|daily/")

(defun jnf/force-org-rebuild-cache ()
  "Rebuild the `org-mode' and `org-roam' cache."
  (interactive)
  (org-id-update-id-locations)
  ;; Note: you may need `org-roam-db-clear-all'
  ;; followed by `org-roam-db-sync'
  (org-roam-db-sync)
  (org-roam-update-org-id-locations))

(defun rw/format-rss-feed-entry (entry style project)
  "Format ENTRY for the RSS feed.
ENTRY is a file name.  STYLE is either 'list' or 'tree'.
PROJECT is the current project."
  (cond ((not (directory-name-p entry))
         (let* ((file (org-publish--expand-file-name entry project))
                (title (org-publish-find-title entry project))
                (date (format-time-string "%Y-%m-%d" (org-publish-find-date entry project)))
                (link (concat (file-name-sans-extension entry) ".html")))
           (with-temp-buffer
             (insert (format "* [[file:%s][%s]]\n" file title))
             (org-set-property "RSS_PERMALINK" link)
             (org-set-property "PUBDATE" date)
             (insert-file-contents file)
             (buffer-string))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(defun rw/format-rss-feed (title list)
  "Generate RSS feed, as a string.
TITLE is the title of the RSS feed.  LIST is an internal
representation for the files to include, as returned by
`org-list-to-lisp'.  PROJECT is the current project."
  (concat "#+TITLE: " title "\n\n"
          (org-list-to-subtree list 1 '(:icount "" :istart ""))))

(defun rw/org-rss-publish-to-rss (plist filename pub-dir)
  "Publish RSS with PLIST, only when FILENAME is 'rss.org'.
PUB-DIR is when the output will be placed."
  (if (equal "rss.org" (file-name-nondirectory filename))
      (org-rss-publish-to-rss plist filename pub-dir)))

(setq org-html-validation-link nil)

(setq org-publish-use-timestamps-flag t)

(setq org-id-extra-files
      (find-lisp-find-files project-dir "\.org$"))

(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"/static/style.css\" />")

(setq org-publish-project-alist
      (list (list "lostWiki"
                  :recursive t
                  :base-directory project-dir
                  :publishing-directory project-output-dir
                  :base-extension "org"
                  :toc nil
                  :exclude (regexp-opt '("sunshine" "daily" "globalist"))
                  :auto-sitemap t
                  :base-extension "org"
                  :section-numbers nil
                  :publishing-function #'org-html-publish-to-html)


            (list "lostWikiImages"
              :recurse t
              :base-directory project-dir
              :base-extension "png\\|jpg"
              :publishing-directory project-output-dir
              :publishing-function #'org-publish-attachment)
            (list "lost-css"
              :base-directory project-dir
              :base-extension "css"
              :publishing-directory project-output-dir
              :publishing-function #'org-publish-attachment)
            (list "lost-rss"

                  :base-directory project-dir
                  :base-extension "org"
                  :recursive nil
                  :exclude (regexp-opt '("rss.org" "index.org" "404.org" "sunshine" "daily" "sitemap"))
                  :publishing-function #'rw/org-rss-publish-to-rss
                  :publishing-directory project-output-dir
                  :rss-extension "xml"
                  :html-link-home "/index.html"
                  :html-link-use-abs-url t
                  :html-link-org-files-as-html t
                  :auto-sitemap t
                  :sitemap-filename "rss.org"
                  :sitemap-title "The Lost Wiki"
                  :sitemap-style 'list

                  :sitemap-sort-files 'anti-chronologically
                  :sitemap-function #'rw/format-rss-feed
                  :sitemap-format-entry #'rw/format-rss-feed-entry
                  :auto-sitemap t
                  :sitemap-filename "rss.org"
                  :author "lost robot"
                  :email "")))

(with-batch
 (setq org-roam-db-location "~/.emacs.d/.local/cache/org-roam.db")
 (org-roam-update-org-id-locations))

(with-batch
 (message "Exporting: %s" project-dir)
 (org-publish-all t)
 (message "Export Complete."))
