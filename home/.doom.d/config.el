;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Matt Knox"
      user-mail-address "matthewknox@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(global-set-key (kbd "C-t") 'transpose-sexps)
(global-set-key (kbd "C-M-t") 'transpose-chars)
(global-set-key (kbd "C-f") 'forward-sexp)
(global-set-key (kbd "C-b") 'backward-sexp)
(global-set-key (kbd "C-M-u") 'backward-char)
(global-set-key (kbd "C-M-n") 'forward-char)
(global-set-key (kbd "C-TAB")  'lisp-indent-line)
(global-set-key (kbd "C-w") 'backward-kill-word)
(if (fboundp 'smex)
    (global-set-key "\C-x\C-m" 'smex)
  (global-set-key "\C-x\C-m" 'execute-extended-command))

(global-set-key "\C-x\C-g" 'magit-status)
(global-set-key "\C-x\g" 'magit-status)
(global-set-key [(control x) (control b)] 'electric-buffer-list)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-w" 'kill-buffer-and-maybe-close-frame)
(global-set-key (kbd "M-s") 'save-some-buffers)

(global-set-key (kbd "M-c") 'copy-region-as-kill)
(global-set-key (kbd "M-C") 'capitalize-word)
(global-set-key (kbd "M-v") 'yank)
(global-set-key (kbd "M-V") 'scroll-down)
(global-set-key (kbd "M-X") 'kill-region)
(global-set-key (kbd "C-#") 'universal-argument)

(global-set-key (kbd "C-#") 'universal-argument)
;(global-set-key (kbd "s-[") 'org-roam-insert-immediate)
; (setq org-default-notes-file "~/org/refile.org")
; (setq org-journal-dir "~/org/journal")
(eval-after-load 'org-roam
                    '(define-key org-roam-mode-map (kbd "M-[") 'org-roam-insert-immediate))
(setq org-todo-keywords
      '((sequence "TODO(t!)" "STARTED(s@/!)" "BLOCKED(b@/!)" "FUTURE(f@/!)" "INBOX(i!)" "|" "DONE(d@/!)" "HANDOFF(h@/!)" "ABANDONED(a@/!)" "JUNKDRAWER(j@/!)")))
;; (setq org-todo-keywords
;; ((sequence "TODO(t)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)"
;;            "|" "DONE(d)" "KILL(k)")
;;  (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)"))
;;  )
(global-set-key (kbd "s-[") 'org-roam-insert-immediate)

(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t!)"  ; A task that needs doing & is ready to do
           "PROJ(p)"   ; A project, which usually contains other tasks
           "STARTED(s@/!)"  ; A task that is in progress
           "WAIT(w@/!)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "FUTURE(f@/!)"   ; in da futcha
           "INBOX(i!)"   ; to be processed in GTD flows (maybe redundant?)
           "|"
           "DONE(d)"  ; Task successfully completed
           "HANDOFF(h@/!)"
           "ABANDONED(a@/!)"
           "JUNKDRAWER(j@/!)"
           "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)")) ; Task was completed
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STARTED" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project))))
