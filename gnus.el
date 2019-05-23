(require 'nnir)

;; You need this to be able to list all labels in gmail
(setq gnus-ignored-newsgroups "")
(setq gnus-activate-level 2)

;; @see http://www.emacswiki.org/emacs/GnusGmail#toc1
;;(setq gnus-select-method '(nntp "news.gmane.org")) ;; if you read news groups
(setq gnus-select-method
      '(nnnil ""))

;; ask encryption password once
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; @see http://gnus.org/manual/gnus_397.html
(add-to-list 'gnus-secondary-select-methods
             '(nnimap "gmail1"
                      (nnimap-address "imap.gmail.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      (nnimap-authinfo-file "~/.authinfo.gpg")
                      ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
                      ;; press 'E' to expire email
                      (nnmail-expiry-target "nnimap+gmail1:[Gmail]/Trash")
                      (nnmail-expiry-wait 90)))

;; OPTIONAL, the setup for Microsoft Hotmail
(add-to-list 'gnus-secondary-select-methods
             '(nnimap "gmail2"
                      (nnimap-address "imap.gmail.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                     (nnimap-authinfo-file "~/.authinfo.gpg")
                      (nnir-search-engine imap)
                      (nnmail-expiry-target "nnimap+gmail2:[Gmail]/Trash")
                      (nnmail-expiry-wait 90)))

(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-most-recent-date
        (not gnus-thread-sort-by-number)))

; NO 'passive
(setq gnus-use-cache t)

;; {{ press "o" to view all groups
(defun my-gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without un-read messages"
  (interactive)
  (gnus-group-list-all-groups 5))

(define-key gnus-group-mode-map
  ;; list all the subscribed groups even they contain zero un-read messages
  (kbd "o") 'my-gnus-group-list-subscribed-groups)
;; }}

;; Fetch only part of the article if we can.
;; I saw this in someone's .gnus
(setq gnus-read-active-file 'some)

;; open attachment
(eval-after-load 'mailcap
  '(progn
     (cond
      ;; on macOS, maybe change mailcap-mime-data?
      ((eq system-type 'darwin))
      ;; on Windows, maybe change mailcap-mime-data?
      ((eq system-type 'windows-nt))
      (t
       ;; Linux, read ~/.mailcap
       (mailcap-parse-mailcaps)))))

;; Tree view for groups.
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; Threads!  I hate reading un-threaded email -- especially mailing
;; lists.  This helps a ton!
(setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)

;; Also, I prefer to see only the top level message.  If a message has
;; several replies or is part of a thread, only show the first message.
;; `gnus-thread-ignore-subject' will ignore the subject and
;; look at 'In-Reply-To:' and 'References:' headers.
(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

;; Personal Information
(setq user-full-name (rot13 "Iraxngrfu Funezn")
      user-mail-address (rot13 "iraxngrfu.xf@tznvy.pbz"))


;; ;; ;; Send email through SMTP
;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587
;;       smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg")
;;       )

;; (defun bst-change-smtp ()
;;   "Change the SMTP server according to the current from line."
;;   (save-excursion
;;     (save-restriction
;;       (message-narrow-to-headers)
;;       (let* ((from (message-fetch-field "from"))
;;              (from-first (string-match (rot13 "iraxngrfu.xf@tznvy.pbz") from))
;;              (from-second (string-match (rot13 "ernpuxfi@tznvy.pbz") from)))
;;         (setq smtpmail-smtp-service (if from-first 587 smtpmail-smtp-service) ; the SMTP port at work is different
;;               smtpmail-smtp-server (if from-first
;;                                        "smtp.gmail.com"                ; the SMTP server at work
;;                                      smtpmail-default-smtp-server)              ; the SMTP server otherwise
;;               smtpmail-stream-type 'starttls
;;               smtpmail-default-smtp-server smtpmail-smtp-server)
;;         (message-remove-header "X-Message-SMTP-Method")))))

;; (add-hook 'message-send-hook 'bst-change-smtp)




;; sending mail
(setq message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "/usr/local/bin/msmtp"
      user-full-name "Venkatesh K S")


;; Borrowed from http://ionrock.org/emacs-email-and-mu.html
;; Choose account label to feed msmtp -a option based on From header
;; in Message buffer; This function must be added to
;; message-send-mail-hook for on-the-fly change of From address before
;; sending message since message-send-mail-hook is processed right
;; before sending message.
(defun choose-msmtp-account ()
  (if (message-mail-p)
      (save-excursion
        (let*
            ((from (or (save-restriction
                         (message-narrow-to-headers)
                         (message-fetch-field "from")) ""))
             (cc (or (save-restriction
                       (message-narrow-to-headers)
                       (message-fetch-field "gcc")) ""))
             (account
              (cond
               ((or (string-match (rot13 "iraxngrfu.xf@tznvy.pbz") from)
                    (string-match  "asjndshs977sduyttysdsyds" cc)) "gmail1")
               ((string-match (rot13 "ernpuxfi@tznvy.pbz") from) "gmail2")
               )))
          (setq message-sendmail-extra-arguments (list '"-a" account))))))
(setq message-sendmail-envelope-from 'header)
(add-hook 'message-send-mail-hook 'choose-msmtp-account)

;; Need to tell msmtp which account we're using
(setq message-sendmail-extra-arguments '("--read-envelope-from"))
(setq message-sendmail-f-is-evil 't)




;; http://www.gnu.org/software/emacs/manual/html_node/gnus/_005b9_002e2_005d.html
(setq gnus-use-correct-string-widths nil)


;; Sample on how to organize mail folders.
;; It's dependent on `gnus-topic-mode'.
(eval-after-load 'gnus-topic
  '(progn
     (setq gnus-message-archive-group '((format-time-string "sent.%Y")))
     (setq gnus-server-alist '(("archive" nnfolder "archive" (nnfolder-directory "~/Mail/archive")
                                (nnfolder-active-file "~/Mail/archive/active")
                                (nnfolder-get-new-mail nil)
                                (nnfolder-inhibit-expiry t))))

     ;; "Gnus" is the root folder, and there are three mail accounts, "misc", "hotmail", "gmail"
     (setq gnus-topic-topology '(("Gnus" visible)
                                 (("misc" visible))
                                 (("gmail1" visible))
                                 (("gmail2" visible))
                                 ))

     ;; each topic corresponds to a public imap folder
     (setq gnus-topic-alist '(("gmail1" ; the key of topic
                               "nnimap+gmail1:INBOX"
                               "nnimap+gmail1:[Gmail]/Sent Mail"
                               "nnimap+gmail1:[Gmail]/Trash"
                               "nnimap+gmail1:Sent Messages"
                               "nnimap+gmail1:Drafts")
                              ("gmail2" ; the key of topic
                               "nnimap+gmail2:INBOX"
                               "nnimap+gmail2:[Gmail]/Sent Mail"
                               "nnimap+gmail2:[Gmail]/Trash"
                               "nnimap+gmail2:Sent Messages"
                               "nnimap+gmail2:Drafts")
                              ("misc"
                               "nnimap+gmail1:Clojure")
                              ("Gnus")))
     ))

(setq gnus-posting-styles
      '(("gmail1:INBOX"
         (name (rot13 "Iraxngrfu Funezn"))
         (address (rot13 "iraxngrfu.xf@tznvy.pbz"))
         ("X-Message-SMTP-Method" (rot13 "fzgc fzgc.tznvy.pbz 587 iraxngrfu.xf@tznvy.pbz")))
        ("gmail2:INBOX"
         (address (rot13 "ernpuxfi@tznvy.pbz"))
         (name (rot13 "Iraxngrfu Funezn"))
         ("X-Message-SMTP-Method" (rot13 "fzgc fzgc.tznvy.pbz 587 ernpuxfi@tznvy.pbz")))))

;; (setq smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587
;;       gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")


(setq gnus-parameters
      '(("nnimap gmail1:INBOX"
         (display . all)
         (posting-style
          (name (rot13 "Iraxngrfu Funezn"))
          (address (rot13 "iraxngrfu.xf@tznvy.pbz"))
          (eval (setq message-sendmail-extra-arguments '("-a" "primary")))
          (organization "")
          (user-mail-address (rot13 "iraxngrfu.xf@tznvy.pbz"))
          ;; (signature-file "~/.signature-work")
          )
         (expiry-wait . never)
         (expiry-target . delete))

        ("nnimap gmail2:[Gmail]/.*"
         (display . all)
         (posting-style
          (name (rot13 "Iraxngrfu Funezn"))
          (address (rot13 "ernpuxfi@tznvy.pbz"))
          ;; (organization "My Employer")
          ;; (signature-file "~/.signature-work")
          )
         (expiry-wait . never)
         (expiry-target . delete)
         )
        ;; ("nnimap home:(INBOX|lists..*)"
        ;;  (display . all)
        ;;  (posting-style
        ;;   (name "Deon Garrett")
        ;;   (address "me@myhomeaddress.com")
        ;;   (signature-file "~/.signature-home"))
        ;;  (expiry-target . delete)
        ;; ("nnimap home:[Gmail]/.*"
        ;;  (display . all)
        ;;  (posting-style
        ;;   (name "Deon Garrett")
        ;;   (address "me@myhomeaddress.com")
        ;;   (signature-file "~/.signature-home"))
        ;;  (expiry-wait . never)))
        ))



(when window-system
  (setq gnus-sum-thread-tree-indent "  ")
  (setq gnus-sum-thread-tree-root "● ")
  (setq gnus-sum-thread-tree-false-root "◯ ")
  (setq gnus-sum-thread-tree-single-indent "◎ ")
  (setq gnus-sum-thread-tree-vertical        "│")
  (setq gnus-sum-thread-tree-leaf-with-other "├─► ")
  (setq gnus-sum-thread-tree-single-leaf     "╰─► "))
(setq gnus-summary-line-format
      (concat
       "%0{%U%R%z%}"
       "%3{│%}" "%1{%d%}" "%3{│%}" ;; date
       "  "
       "%4{%-20,20f%}"               ;; name
       "  "
       "%3{│%}"
       " "
       "%1{%B%}"
       "%s\n"))
(setq gnus-summary-display-arrow t)

(gnus-add-configuration
 '(article
   (horizontal 1.0
               (vertical 33 (group 1.0))
               (vertical 1.0
                         (summary 0.20 point)
                         (article 1.0)))))

(gnus-add-configuration
 '(summary
   (horizontal 1.0
               (vertical 33 (group 1.0))
               (vertical 1.0 (summary 1.0 point)))))



;; From https://github.com/dbjergaard/dotfiles/blob/698069a65b0cb88fd98a30fd2271c0bc129141ea/gnus
(add-hook 'message-mode-hook 'orgstruct++-mode 'append)
(add-hook 'message-mode-hook 'turn-on-auto-fill 'append)
(add-hook 'message-mode-hook 'orgtbl-mode 'append)
(add-hook 'message-mode-hook 'turn-on-flyspell 'append)
(add-hook 'message-mode-hook
          '(lambda () (setq fill-column 72))
          'append)
(add-hook 'message-mode-hook
          '(lambda () (local-set-key (kbd "C-c M-o") 'org-mime-htmlize))
          'append)


;; @see https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/gnus-guide-en.org
;; gnus-group-mode
(eval-after-load 'gnus-group
  '(progn
     (defhydra hydra-gnus-group (:color blue)
       "
[_A_] Remote groups (A A) [_g_] Refresh
[_L_] Local groups        [_\\^_] List servers
[_c_] Mark all read       [_m_] Compose new mail
[_G_] Search mails (G G) [_#_] Mark mail
"
       ("A" gnus-group-list-active)
       ("L" gnus-group-list-all-groups)
       ("c" gnus-topic-catchup-articles)
       ("G" gnus-group-make-nnir-group)
       ("g" gnus-group-get-new-news)
       ("^" gnus-group-enter-server-mode)
       ("m" gnus-group-new-mail)
       ("#" gnus-topic-mark-topic)
       ("q" nil))
     ;; y is not used by default
     (define-key gnus-group-mode-map "y" 'hydra-gnus-group/body)))

;; gnus-summary-mode
(eval-after-load 'gnus-sum
  '(progn
     (defhydra hydra-gnus-summary (:color blue)
       "
[_s_] Show thread   [_F_] Forward (C-c C-f)
[_h_] Hide thread   [_e_] Resend (S D e)
[_n_] Refresh (/ N) [_r_] Reply
[_!_] Mail -> disk  [_R_] Reply with original
[_d_] Disk -> mail  [_w_] Reply all (S w)
[_c_] Read all      [_W_] Reply all with original (S W)
[_#_] Mark          [_G_] Search mails in current folder
"
       ("s" gnus-summary-show-thread)
       ("h" gnus-summary-hide-thread)
       ("n" gnus-summary-insert-new-articles)
       ("F" gnus-summary-mail-forward)
       ("!" gnus-summary-tick-article-forward)
       ("d" gnus-summary-put-mark-as-read-next)
       ("c" gnus-summary-catchup-and-exit)
       ("e" gnus-summary-resend-message-edit)
       ("R" gnus-summary-reply-with-original)
       ("r" gnus-summary-reply)
       ("W" gnus-summary-wide-reply-with-original)
       ("w" gnus-summary-wide-reply)
       ("#" gnus-topic-mark-topic)
       ("G" gnus-summary-make-nnir-group)
       ("q" nil))
     ;; y is not used by default
     (define-key gnus-summary-mode-map "y" 'hydra-gnus-summary/body)))

;; gnus-article-mode
(eval-after-load 'gnus-art
  '(progn
     (defhydra hydra-gnus-article (:color blue)
       "
[_o_] Save attachment        [_F_] Forward
[_v_] Play video/audio       [_r_] Reply
[_d_] CLI to dowloand stream [_R_] Reply with original
[_b_] Open external browser  [_w_] Reply all (S w)
[_f_] Click link/button      [_W_] Reply all with original (S W)
[_g_] Focus link/button
"
       ("F" gnus-summary-mail-forward)
       ("r" gnus-article-reply)
       ("R" gnus-article-reply-with-original)
       ("w" gnus-article-wide-reply)
       ("W" gnus-article-wide-reply-with-original)
       ("o" gnus-mime-save-part)
       ("v" w3mext-open-with-mplayer)
       ("d" w3mext-download-rss-stream)
       ("b" w3mext-open-link-or-image-or-url)
       ("f" w3m-lnum-follow)
       ("g" w3m-lnum-goto)
       ("q" nil))
     ;; y is not used by default
     (define-key gnus-article-mode-map "y" 'hydra-gnus-article/body)))

;; message-mode
(eval-after-load 'message
  '(progn
     (defhydra hydra-message (:color blue)
  "
[_c_] Complete mail address
[_a_] Attach file
[_s_] Send mail (C-c C-c)
"
       ("c" counsel-bbdb-complete-mail)
       ("a" mml-attach-file)
       ("s" message-send-and-exit)
       ("i" dianyou-insert-email-address-from-received-mails)
       ("q" nil))))

(defun message-mode-hook-hydra-setup ()
  (local-set-key (kbd "C-c C-y") 'hydra-message/body))
(add-hook 'message-mode-hook 'message-mode-hook-hydra-setup)
