;; emacs kicker --- kick start emacs setup
;; Copyright (C) 2010 Dimitri Fontaine
;;
;; Author: Dimitri Fontaine <dim@tapoueh.org>
;; URL: https://github.com/dimitri/emacs-kicker
;; Created: 2011-04-15
;; Keywords: emacs setup el-get kick-start starter-kit
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/
;;
;; This file is NOT part of GNU Emacs.

(toggle-debug-on-error t)
(defvar *emacs-load-start* (current-time))
(require 'cl)				; common lisp goodies, loop

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

; TODO: make this require my forked version.
(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://github.com/dimitri/el-get/raw/master/el-get-install.el")
    (end-of-buffer)
    (eval-print-last-sexp)))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move			; have to add your own keys
	  :after (progn
		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

   (:name smex				; a better (ido like) M-x
	  :after (progn
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name magit				; git meet emacs, and a binding
	  :after (progn
		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name ruby-mode
	  :type elpa
	  :load "ruby-mode.el")
   (:name inf-ruby  :type elpa)
   (:name ruby-compilation :type elpa)
;   (:name css-mode :type elpa)
   (:name textmate
	  :type git
	  :url "git://github.com/defunkt/textmate.el"
	  :load "textmate.el")
   (:name rhtml
	  :type git
	  :url "git://github.com/eschulte/rhtml"
	  :features rhtml-mode)
   (:name goto-last-change		; move pointer back to last change
	  :after (progn
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; now set our own packages
(setq
 my:el-get-packages
 '(;el-get				; el-get is self-hosting
   escreen            			; screen for emacs, C-\ C-h
   switch-window			; takes over C-x o
   auto-complete			; complete as you type with overlays
   yasnippet 				; powerful snippet mode
   zencoding-mode			; http://www.emacswiki.org/emacs/ZenCoding
   color-theme		                ; nice looking emacs

   ;; makes handling lisp expressions much, much easier
   ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
   paredit

   ;; key bindings and code colorization for Clojure
   ;; https://github.com/clojure-emacs/clojure-mode
   clojure-mode

   ;; extra syntax highlighting for clojure
;   clojure-mode-extra-font-locking

   ;; integration with a Clojure REPL
   ;; https://github.com/clojure-emacs/cider
   cider

   ;; allow ido usage in as many contexts as possible. see
   ;; customizations/navigation.el line 23 for a description
   ;; of ido
   ido-ubiquitous
   js2-mode
   js2-refactor
   coffee-mode
   color-theme-tango))	                ; check out color-theme-solarized

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (ignore-errors (el-get-executable-find "cvs"))
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (ignore-errors (el-get-executable-find "svn"))
  (loop for p in '(psvn    		; M-x svn-status
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

;; on to the visual settings
(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars
(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-10")
  (set-face-font 'default "Monospace-10"))

(global-hl-line-mode)			; highlight current line
; (global-linum-mode 1)			; add line numbers on the left
(color-theme-tango)
(toggle-frame-maximized)
(setq mouse-drag-copy-region t)

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; avoid compiz manager rendering bugs.  Whut?
(add-to-list 'default-frame-alist '(alpha . 100))

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(require 'term)
(define-key term-raw-map  (kbd "C-'") 'term-line-mode)
(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map  (kbd "C-y") 'term-paste)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)
(setq ido-default-buffer-method 'selected-window)
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!

(setq autosave-dir "~/.emacs.d/emacs_autosaves/")
(make-directory autosave-dir t)
;(setq auto-save-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat autosave-dir "\\1") t)))
;(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))
;(setq auto-save-file-name-transforms `((".*\\([^/]*\\)" "~/.emacs.d/matt/emacs_autosaves/\\1" t)))
; yet another failed attempt at fixing auto-save-file-name-transforms
(setq make-backup-files nil)
(setq auto-save-default nil)
(show-paren-mode t)

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(setq backup-dir "~/.emacs.d/emacs_backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))
(make-directory backup-dir t)

(setq kill-whole-line t)
(setq ido-case-fold nil)
(setq ido-use-url-at-point nil)
(column-number-mode)

(setq ns-pop-up-frames nil)

(push "/usr/local/bin" exec-path)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(defun run-servers ()
  (edit-server-start)
  (server-start))

; use default Mac browser
;(setq browse-url-browser-function 'browse-url-default-macosx-browser)


;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
;(global-set-key (kbd "C-x C-c") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; have vertical ido completion lists
(setq ido-decorations
      '("\n-> " "" "\n   " "\n   ..." "[" "]"
	" [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]"))

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

; like universal argument, don't use it much, need C-u
(global-set-key (kbd "C-S-u") 'universal-argument)
(global-set-key (kbd "C-u") 'forward-sexp)
(global-set-key (kbd "C-t") 'transpose-sexps)
(global-set-key (kbd "C-M-t") 'transpose-chars)
(global-set-key (kbd "C-o") 'backward-sexp)
(global-set-key (kbd "C-M-u") 'backward-char)
(global-set-key (kbd "C-n") 'next-line)
(global-set-key (kbd "C-a") 'beginning-of-line)
(global-set-key (kbd "C-p") 'previous-line)
(global-set-key (kbd "C-M-n") 'forward-char)
(global-set-key (kbd "C-TAB")  'lisp-indent-line)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key "\C-x\C-m" 'smex)

(global-set-key "\C-x\C-g" 'magit-status)
(global-set-key "\C-x\g" 'magit-status)
(global-set-key "\M-T" 'textmate-goto-symbol)
(global-set-key [(control x) (control b)] 'electric-buffer-list)

(global-set-key "\C-\M-h" 'backward-kill-word)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-r" 'jump-to-register)

(global-set-key "\M-w" 'kill-buffer-and-maybe-close-frame)
(global-set-key "\M-W" 'kill-this-buffer)
(global-set-key (kbd "A-w") 'kill-this-buffer)
(global-set-key "\M-t" 'textmate-goto-file)
(global-set-key "\M-#" 'comment-dwim) ; TODO: should this be paredit-comment-dwim?
(global-set-key (kbd "M-DEL") 'backward-kill-sexp)
(global-set-key "\C-xh" (lambda (url) (interactive "MUrl: ")
			  (switch-to-buffer (url-retrieve-synchronously url))
			  (rename-buffer url t)
			  (html-mode)))

(global-set-key [C-tab] 'other-window)
(global-set-key (kbd "<C-left>")  'windmove-left)
(global-set-key (kbd "<C-right>") 'windmove-right)
(global-set-key (kbd "<C-up>")    'windmove-up)
(global-set-key (kbd "<C-down>")  'windmove-down)
(global-set-key "\C-c\C-g" 'gist-buffer-confirm)
(global-set-key (kbd "C-S-N") 'word-count)
(global-set-key (kbd "A-F") 'ack)
(global-set-key (kbd "<f1>") 'maximize-frame)
(global-set-key (kbd "<S-backspace>") 'kill-region)
(global-set-key (kbd "M-s") 'save-some-buffers)
(global-set-key (kbd "M-r") 'ido-find-alternate-file)

(global-set-key (kbd "M-c") 'copy-region-as-kill)
(global-set-key (kbd "M-C") 'capitalize-word)
(global-set-key (kbd "M-v") 'yank)
(global-set-key (kbd "M-V") 'scroll-down)
(global-set-key (kbd "M-X") 'kill-region)


(global-set-key (kbd "C-#") 'universal-argument)

; (global-set-key (kbd "A-tab") 'slime-eval-print-last-expression)

;; mode-specific keybindings: maybe move these to their own file(s)?
(eval-after-load "paredit" '(define-key paredit-mode-map (kbd "TAB") 'slime-complete-symbol))
(eval-after-load "paredit"
  '(define-key paredit-mode-map (kbd ")")
     'paredit-close-parenthesis))
(eval-after-load "paredit"
  '(define-key paredit-mode-map (kbd "M-)")
     'paredit-close-parenthesis-and-newline))

;(define-key term-mode-map (kbd "A-h") 'term-char-mode)
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(defun mark-string ()
  (interactive)
  (setq deactivate-mark nil)
  (push-mark (search-forward "\"") t t)
  (search-backward "\""))

(defun ff/move-region-to-fridge ()
  (interactive)
  "Cut the current region, paste it in a file called ./fridge with a time tag, and save this file"
  (unless (use-region-p) (error "No region selected"))
  (let ((bn (file-name-nondirectory (buffer-file-name))))
    (kill-region (region-beginning) (region-end))
    (with-current-buffer (find-file-noselect "fridge")
      (goto-char (point-max))
      (insert "\n")
      (insert "######################################################################\n")
      (insert "\n" (format-time-string "%Y %b %d %H:%M:%S" (current-time)) " (from " bn ")\n\n")
      (yank)
      (save-buffer)
      (message "Region moved to fridge"))))

(defun url-fetch-into-buffer (url)
  (interactive "sURL:")
  (insert (concat "\n\n" ";; " url "\n"))
  (insert (url-fetch-to-string url)))

(defun url-fetch-to-string (url)
  (with-current-buffer (url-retrieve-synchronously url)
    (beginning-of-buffer)
    (search-forward-regexp "\n\n")
    (delete-region (point-min) (point))
    (buffer-string)))

(defun gist-buffer-confirm (&optional private)
  (interactive "P")
  (when (yes-or-no-p "Are you sure you want to Gist this buffer? ")
    (gist-region-or-buffer private)))


(defun ruby-interpolate ()
  "In a double quoted string, interpolate."
  (interactive)
  (insert "#")
  (let ((properties (text-properties-at (point))))
    (when (and
           (memq 'font-lock-string-face properties)
           (save-excursion
             (ruby-forward-string "\"" (line-end-position) t)))
      (insert "{}")
      (backward-char 1))))

(defun kill-buffer-and-maybe-close-frame ()
  "definitely kill this buffer, close frame if >2 frames exist"
  (interactive)
  (kill-this-buffer)
  (setq number-of-frames 0)
  (walk-windows (lambda (x) (setq number-of-frames (+ 1 number-of-frames))))
  (if (< 2 number-of-frames)
      (delete-window)))

;; this is from rails-lib.el in the emacs-rails package
(defun string-join (separator strings)
  "Join all STRINGS using SEPARATOR."
  (mapconcat 'identity strings separator))

(defun align-to-equals (begin end)
  "Align region to equal signs"
  (interactive "r")
  (align-regexp begin end "\\(\\s-*\\)=" 1 1 ))



(defun count-words (&optional begin end)
  "count words between BEGIN and END (region); if no region defined, count words in buffer"
  (interactive "r")
  (let ((b (if mark-active begin (point-min)))
        (e (if mark-active end (point-max))))
    (message "Word count: %s" (how-many "\\w+" b e))))

(defun delete-this-file ()
  (interactive)
  (or (buffer-file-name) (error "no file is currently being edited"))
  (when (yes-or-no-p "Really delete this file?")
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

(defun move-end-of-line-or-next-line ()
  (interactive)
  (if (eolp)
      (next-line)
    (move-end-of-line nil)))
;(global-set-key "\C-e" 'move-end-of-line-or-next-line)

(defun move-start-of-line-or-prev-line ()
  (interactive)
  (if (bolp)
      (previous-line)
    (move-beginning-of-line nil)))
;(global-set-key "\C-a" 'move-start-of-line-or-prev-line)


(global-set-key "\C-co" 'switch-to-minibuffer) ;; Bind to `C-c o'
(global-set-key "\C-c\C-o" 'switch-to-minibuffer) ;; Bind to `C-c C-o'
(setq js-indent-level 2)

(defun ruby-mode-hook ()
  (autoload 'ruby-mode "ruby-mode" nil t)
  (add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
  (add-hook 'ruby-mode-hook '(lambda ()
                               (setq ruby-deep-arglist t)
                               (setq ruby-deep-indent-paren nil)
                               (setq c-tab-always-indent nil)
                               (require 'inf-ruby)
                               (require 'ruby-compilation)
                               (define-key ruby-mode-map (kbd "M-r") 'run-rails-test-or-ruby-buffer))))
(defun rhtml-mode-hook ()
  (autoload 'rhtml-mode "rhtml-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . rhtml-mode))
  (add-to-list 'auto-mode-alist '("\\.rjs\\'" . rhtml-mode))
  (add-hook 'rhtml-mode '(lambda ()
                           (define-key rhtml-mode-map (kbd "M-s") 'save-buffer))))

(defun yaml-mode-hook ()
  (autoload 'yaml-mode "yaml-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode)))

(defun css-mode-hook ()
  (autoload 'css-mode "css-mode" nil t)
  (add-hook 'css-mode-hook '(lambda ()
                              (setq css-indent-level 2)
                              (setq css-indent-offset 2))))
(defun is-rails-project ()
  (when (textmate-project-root)
    (file-exists-p (expand-file-name "config/environment.rb" (textmate-project-root)))))

(defun run-rails-test-or-ruby-buffer ()
  (interactive)
  (if (is-rails-project)
      (let* ((path (buffer-file-name))
             (filename (file-name-nondirectory path))
             (test-path (expand-file-name "test" (textmate-project-root)))
             (command (list ruby-compilation-executable "-I" test-path path)))
        (pop-to-buffer (ruby-compilation-do filename command)))
    (ruby-compilation-this-buffer)))

(defvar programming-modes
  '(emacs-lisp-mode
    scheme-mode
    lisp-mode
    c-mode
    c++-mode
    ruby-mode
    objc-mode
    latex-mode
    plain-tex-mode
    java-mode
    php-mode
    css-mode
    js2-mode
    nxml-mode
    nxhtml-mode)
  "List of modes related to programming")

; Text-mate style indenting
(defadvice yank (after indent-region activate)
  (if (member major-mode programming-modes)
      (indent-region (region-beginning) (region-end) nil)))

(defalias 'yes-or-no-p 'y-or-n-p)
(require 'server)
(unless (server-running-p)
  (server-start))

;; load time measurement.
(defvar *emacs-load-time* (destructuring-bind (hi lo ms _) (current-time)
                            (- (+ hi lo) (+ (first *emacs-load-start*)
                                            (second *emacs-load-start*)))))

(message "My .emacs loaded in %d s" *emacs-load-time*)
(toggle-debug-on-error nil)
