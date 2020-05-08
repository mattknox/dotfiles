;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(toggle-debug-on-error t)
(defvar *emacs-load-start* (current-time))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;; these are the packages I've installed explicitly. 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "43c1a8090ed19ab3c0b1490ce412f78f157d69a29828aa977dae941b994b4147" default)))
 '(debug-on-error t)
 '(package-selected-packages
   (quote
    (use-package ivy helm org-roam deft xml-rpc jira ox-jira zenburn-theme spacegray-theme gruvbox-theme molokai-theme color-theme-sanityinc-solarized 4clojure cider-decompile cider-eval-sexp-fu cider-spy circe clojure-mode clojurescript-mode ox-gfm htmlize color-theme-tango tangotango-theme naquadah-theme color-theme buffer-move magit smex org-plus-contrib org prettier-js thrift roguel-ike projectile-rails clj-refactor inf-clojure cider elm-mode w3m bbdb anki-editor code-library org-mime ethan-wspace org-blog org-jira org-journal gist clj-mode cljsbuild-mode clojure-cheatsheet geiser gh ghc tumble twittering-mode typed-clojure-mode typescript-mode ruby-mode ruby-compilation rinari robe ## queue))))
(ignore-errors (package-install-selected-packages))

(require 'cl) ; common lisp goodies, loop

(add-hook 'clojure-mode-hook           #'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)

;; on to the visual settings
(setq inhibit-splash-screen t) ; no splash screen, thanks
(line-number-mode 1) ; have line numbers and
(column-number-mode 1) ; column numbers in the mode line

(tool-bar-mode -1)         ; no tool bar with icons
(scroll-bar-mode -1) ; no scroll bars
(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-10")
  (set-face-font 'default "Monospace-10"))

(global-hl-line-mode)  ; highlight current line
; (global-linum-mode 1) ; add line numbers on the left
(ignore-errors  (if (fboundp 'color-theme-solarized)
                    (color-theme-solarized)
                  (if (load-theme 'leuven t)
                      (load-theme 'leuven-dark t))))
(toggle-frame-maximized)
(setq mouse-drag-copy-region t)

(require 'org)

; setup for orgflow:
(if (file-exists-p (expand-file-name "~/h/orgflow/orgflow.el" ))
    (load (expand-file-name "~/h/orgflow/orgflow" )))


;; delete trailing whitespace
;; had to disable this because it was causing problems with reddit
;; code reviews, where sloppy trailing whitespace was pretty common.
;(add-hook 'before-save-hook 'delete-trailing-whitespace)


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

;; org-mode config
;(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

(setq org-log-done t)
(setq org-agenda-files (quote ("~/org/")))
(setq org-default-notes-file "~/org/refile.org")
(setq org-journal-dir "~/org/journal")

; grabbed this from https://orgmode.org/manual/Clocking-work-time.html#Clocking-work-time
; the intent is to make emacs assume that I did not work when away from emacs.
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(setq mac-option-modifier 'meta) ; for compatibility between terminal and app emacs.
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
  (if (< 3 number-of-frames)
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

(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; http://www.flycheck.org/manual/latest/index.html

;; disable jshint since we prefer eslint checking
(if (require 'flycheck nil t)
    (setq-default flycheck-disabled-checkers
                  (append flycheck-disabled-checkers
                          '(javascript-jshint))))

(setq ruby-insert-encoding-magic-comment nil)
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
                               (require 'ruby-electric-mode)
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

(defun wenshan-split-window-vertical (&optional wenshan-number)
  "Split the current window into `wenshan-number' windows"
  (interactive "P")
  (setq wenshan-number (if wenshan-number
                           (prefix-numeric-value wenshan-number)
                         2))
  (while (> wenshan-number 1)
    (split-window-right)
    (setq wenshan-number (- wenshan-number 1)))
  (balance-windows))

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

(progn (split-window-right)
       (balance-windows))

(require 'ruby-mode)
;; TODO: fix this shit.  It bananas.
(setq require-final-newlines nil)
(setq require-final-newline nil)
(setq mode-require-final-newline nil)
(setq mode-require-final-newlines nil)
(require 'ethan-wspace)
(global-ethan-wspace-mode 1)
(setq magit-repository-directories `(("~/.homesick/repos/dotfiles" . 0) ("~/h/reddit" . 1)))

;; fix the PATH variable
;; (defun set-exec-path-from-shell-PATH ()
;;   (let ((path-from-shell (shell-command-to-string "TERM=vt100 $SHELL -i -c 'echo $PATH'")))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (when window-system (set-exec-path-from-shell-PATH))

;; org-roam config
(require 'org-roam)
(define-key org-roam-mode-map (kbd "C-c n l") #'org-roam)
(define-key org-roam-mode-map (kbd "C-c n f") #'org-roam-find-file)
(define-key org-roam-mode-map (kbd "C-c n j") #'org-roam-jump-to-index)
(define-key org-roam-mode-map (kbd "C-c n b") #'org-roam-switch-to-buffer)
(define-key org-roam-mode-map (kbd "C-c n g") #'org-roam-graph)
(define-key org-mode-map (kbd "C-c n i") #'org-roam-insert)
(org-roam-mode +1)
(setq org-roam-directory "~/org/")
(setq org-roam-buffer "*roamn-mattknox*")
(setq org-roam-completion-system 'ivy)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-mode-line-clock ((t (:foreground "red" :box (:line-width -1 :style released-button))))))

;; load time measurement.
(defvar *emacs-load-time* (destructuring-bind (hi lo ms _) (current-time)
                            (- (+ hi lo) (+ (first *emacs-load-start*)
                                            (second *emacs-load-start*)))))
(message "My .emacs loaded in %d s" *emacs-load-time*)
(toggle-debug-on-error nil)
