(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (emms ensime elfeed jupyter ein ob-ipython google-c-style scala-mode transient git-gutter cmake-ide cmake-font-lock cmake-mode ccls webpaste all-the-icons-dired all-the-icons paradox wiki-summary thrift dap-java cquery multiple-cursors org-jira treemacs dap-mode lsp-java pyvenv lsp-python company-lsp lsp-ui lsp-mode pipenv use-package ess eyebrowse vlf tabbar-ruler tabbar company-jedi lispy ggtags imenu-list yaml-mode web-mode cider clojure-mode helm-ag helm-descbinds key-chord helm-projectile helm anaconda-mode ripgrep markdown-mode exec-path-from-shell zop-to-char zenburn-theme which-key volatile-highlights undo-tree smartrep smartparens smart-mode-line operate-on-number move-text magit projectile imenu-anywhere hl-todo guru-mode grizzl god-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region epl editorconfig easy-kill diminish diff-hl discover-my-major crux browse-kill-ring beacon anzu ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'c-mode-hook 'ggtags-mode)
(add-hook 'python-mode-hook 'ggtags-mode)

;; Start maximised (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
;; (add-to-list 'load-path "lpy")
;; (load-library "~/.emacs.d/personal/my-custom-python.el")
(global-set-key "\M-p" 'ggtags-prev-mark)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic emacs configuration to be used in conjunction with prelude       ;;
;; pragmaticemacs.com/installing-and-setting-up-emacs/                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Add MELPA repository for packages
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; (add-to-list 'package-archives '("melpa-stable" . "https://melpa-stable.milkbox.net/packages/") t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prelude options                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; install additional packages - add anyto this list that you want to
;; be installed automatically
(prelude-require-packages '(multiple-cursors ess use-package eyebrowse lsp-mode lsp-ui company-lsp lsp-python pyvenv pipenv ivy lsp-java dap-mode wiki-summary paradox all-the-icons all-the-icons-dired webpaste ccls cmake-mode cmake-font-lock cmake-ide git-gutter transient google-c-style ccls ob-ipython ein jupyter elfeed ensime))

;;Enable arrow keys
(setq prelude-guru nil)

;;smooth scrolling
(setq prelude-use-smooth-scrolling t)

;;uncomment this to use default theme
;;(disable-theme 'zenburn)

;;don't highlight the end of long lines
(setq whitespace-line-column 120)


(use-package eyebrowse
             :diminish eyebrowse-mode
             :config (progn
                       (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
                       (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
                       (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
                       (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
                       (define-key eyebrowse-mode-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
                       (define-key eyebrowse-mode-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
                       (define-key eyebrowse-mode-map (kbd "M-7") 'eyebrowse-switch-to-window-config-7)
                       (define-key eyebrowse-mode-map (kbd "M-8") 'eyebrowse-switch-to-window-config-8)
                       (eyebrowse-mode t)
                       (setq eyebrowse-new-workspace t)))


(use-package lsp-mode
  :ensure t
  :commands lsp
  :config

  ;; make sure we have lsp-imenu everywhere we have LSP
  ;;(require 'lsp-imenu)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
  (add-hook 'lsp-after-open-hook 'lsp-ui-mode)

  ;; Get lsp-python-enable defined
  ;; NB: use either projectile-project-root or ffip-get-project-root-directory
  ;;     or any other function that can be used to find the root directory of a project
  ;; (lsp-define-stdio-client lsp-python "python"
  ;;                          #'projectile-project-root
  ;;                          '("pyls"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
                    :major-modes '(python-mode)
                    :server-id 'pyls))

  ;; If we have to make this work with remote stuff
  ;; (lsp-register-client
  ;;  (make-lsp-client :new-connection (lsp-tramp-connection
  ;;                                    (lsp-make-nc-tramp-command "pyls"))
  ;;                   :major-modes '(python-mode)
  ;;                   :remote? t
  ;;                   :server-id 'pyls-tramp))

  ;; make sure this is activated when python-mode is activated
  ;; lsp-python-enable is created by macro above
  (add-hook 'python-mode-hook #'lsp)

  ;; lsp extras
  (use-package lsp-ui
    :ensure t
    :commands lsp-ui-mode
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
    )

  (use-package company-lsp
    :commands company-lsp
    :config
    (push 'company-lsp company-backends))

  ;; NB: only required if you prefer flake8 instead of the default
  ;; send pyls config via lsp-after-initialize-hook -- harmless for
  ;; other servers due to pyls key, but would prefer only sending this
  ;; when pyls gets initialised (:initialize function in
  ;; lsp-define-stdio-client is invoked too early (before server
  ;; start)) -- cpbotha
  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      ;; TODO: check lsp--cur-workspace here to decide per server / project
      (lsp--set-configuration lsp-cfg)))

  (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg))



(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended))

;; (use-package org-jira
(setq jiralib-url "https://datoscloud.atlassian.net/")
;;)


;; ;; C++ setup using cquery
;; (defun cquery//enable ()
;; (condition-case nil
;;     (lsp)
;;   (user-error nil)))

;; (use-package cquery
;;     :commands lsp
;;     :init (add-hook 'c-mode-hook #'cquery//enable)
;;     (add-hook 'c++-mode-hook #'cquery//enable))


(use-package projectile :ensure t)
(use-package treemacs :ensure t)
(use-package yasnippet :ensure t)
(use-package lsp-mode :ensure t)
(use-package hydra :ensure t)
(use-package company-lsp :ensure t)
(use-package lsp-ui :ensure t)
(use-package lsp-java :ensure t :after lsp
  :config (add-hook 'java-mode-hook 'lsp))

;; C++ using ccls
(use-package ccls
  :after projectile
  ;;  :ensure-system-package ccls
  :hook ((c-mode c++-mode) . lsp)
  :custom
  (ccls-args nil)
  (ccls-executable (executable-find "ccls"))
  (projectile-project-root-files-top-down-recurring
   (append '("compile_commands.json" ".ccls")
           projectile-project-root-files-top-down-recurring))
  :config (push ".ccls-cache" projectile-globally-ignored-directories))

;; Cmake modes

;; (use-package cmake-mode
;;   :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

;; (use-package cmake-font-lock
;;   :after (cmake-mode)
;;   :hook (cmake-mode . cmake-font-lock-activate))

;; (use-package cmake-ide
;;   :after projectile
;;   :hook (c++-mode . my/cmake-ide-find-project)
;;   :preface
;;   (defun my/cmake-ide-find-project ()
;;     "Finds the directory of the project for cmake-ide."
;;     (with-eval-after-load 'projectile
;;       (setq cmake-ide-project-dir (projectile-project-root))
;;       (setq cmake-ide-build-dir (concat cmake-ide-project-dir "build")))
;;     (setq cmake-ide-compile-command (concat "cd " cmake-ide-build-dir " && make"))
;;     (cmake-ide-load-db))

;;   (defun my/switch-to-compilation-window ()
;;     "Switches to the *compilation* buffer after compilation."
;;     (other-window 1))
;;   :bind ([remap comment-region] . cmake-ide-compile)
;;   :init (cmake-ide-setup)
;;   :config (advice-add 'cmake-ide-compile :after #'my/switch-to-compilation-window))

;; Google coding style
(use-package google-c-style
  :hook ((c-mode c++-mode) . google-set-c-style)
  (c-mode-common . google-make-newline-indent))

(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java :after (lsp-java))
(use-package lsp-java-treemacs :after (treemacs))

;; (require 'lsp-java)
;; (add-hook 'java-mode-hook #'lsp)


;; Gives a wikipedia summary of the topic
(use-package wiki-summary
  :defer 1
  :bind ("C-c W" . wiki-summary)
  :preface
  (defun my/format-summary-in-buffer (summary)
    "Given a summary, stick it in the *wiki-summary* buffer and display the buffer"
    (let ((buf (generate-new-buffer "*wiki-summary*")))
      (with-current-buffer buf
        (princ summary buf)
        (fill-paragraph)
        (goto-char (point-min))
        (text-mode)
        (view-mode))
      (pop-to-buffer buf))))

(advice-add 'wiki-summary/format-summary-in-buffer :override #'my/format-summary-in-buffer)



;; Give additional information about the package, may be slow
(use-package paradox
  :defer 1
  :custom
  (paradox-column-width-package 27)
  (paradox-column-width-version 13)
  (paradox-execute-asynchronously t)
  (paradox-hide-wiki-packages t)
  :config
  (paradox-enable)
  (remove-hook 'paradox-after-execute-functions #'paradox--report-buffer-print))


;;Font icons
(use-package all-the-icons :defer 0.5)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)


;;webpaste
(use-package webpaste
  :bind (("C-c C-p C-b" . webpaste-paste-buffer)
         ("C-c C-p C-r" . webpaste-paste-region)))


(use-package git-gutter
  :defer 0.3
  :diminish
  :init (global-git-gutter-mode +1))


;; babel

(org-babel-do-load-languages
 'org-babel-load-languages '((shell . t)
                             (python . t)
                             (ipython . t)
                             ))


;; From https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-elfeed.el

(use-package elfeed
  :bind (("C-x w" . elfeed)
         :map elfeed-show-mode-map
         ("o" . ace-link)
         ("q" . delete-window))
  :config
  (setq elfeed-db-directory (locate-user-emacs-file ".elfeed")
        elfeed-show-entry-switch #'pop-to-buffer
        elfeed-show-entry-delete #'delete-window
        url-queue-timeout 30)

  (setq elfeed-feeds
        '(("http://planet.emacsen.org/atom.xml" emacs blog)
          ("http://www.masteringemacs.org/feed/" emacs blog)
          ("https://oremacs.com/atom.xml" emacs blog)
          ("https://pinecast.com/feed/emacscast" emacs blog)
          ("https://www.reddit.com/r/emacs.rss" emacs reddit)
          ("https://www.reddit.com/r/clojure.rss" clojure reddit)
          ("https://nullprogram.com/feed/" dev blog)
          ("https://blog.digitalocean.com/rss/" dev cloud blog)
          ("http://irreal.org/blog/?feed=rss2" emacs blog)
          ("https://www.joelonsoftware.com/feed/" dev blog)
          ("https://mortoray.com/feed/" dev blog)
          ("https://eng.uber.com/feed/" dev blog)
          ("https://nickdesaulniers.github.io/atom.xml" dev blog)
          ("http://sachachua.com/blog/category/emacs/feed/" emacs blog)
          ("https://fgiesen.wordpress.com/feed/" dev blog)
          ("https://arthurcaillau.com/feed.xml" dev blog)
          ("http://gigasquidsoftware.com/atom.xml" ai dev blog)
          ("https://devblogs.nvidia.com/feed/" dev ai blog)
          ("https://devblogs.nvidia.com/gpu-containers-runtime/feed/" dev ai blog)
          ("http://feeds.feedburner.com/thoughtsfromtheredplanet?format=xml" clojure dev blog)
          ("http://cdixon.org/feed/" startups blog)
          ("https://feld.com/feed" startups blog)
          ("http://feeds.feedburner.com/avc" startups blog)
          ("https://a16z.com/feed/" startups blog)
          ("https://www.ben-evans.com/benedictevans?format=RSS" startups blog)
          ("https://bothsidesofthetable.com/feed" startups blog)
          ("https://medium.com/feed/@paraschopra" startups blog)
          ("https://www.forentrepreneurs.com/feed/" startups blog)
          ("https://tomtunguz.com/index.xml" startups blog)
          ("https://www.saastr.com/feed/" startups blog)
          ("https://landing.ai/feed/" startups ai)
          ("http://blog.qure.ai/feed.xml" startups ai healthcare)
          ("https://www.run.ai/feed/" startups ai)
          ("https://medium.com/feed/embleema" startups blockchain)
          ("https://www.merantix.com/feed/" startups ai healthcare)
          ("https://zebramedblog.wordpress.com/feed/" startups ai healthcare)
          ("https://sigtuple.com/feed/" startups ai healthcare)
          ("https://rafay.co/feed/" startups blog)))


  (defhydra elfeed-hydra (:color pink :hint nil)
    "
^Search^                   ^Filter^                 ^Article^
^^-------------------------^^-----------------------^^--------------------
_g_: Refresh               _s_: Live filter         _b_: Browse
_G_: Update                _S_: Set filter          _n_/_C-n_: Next
_y_: Copy URL              _*_: Starred             _p_/_C-p_: Previous
_+_: Tag all               _A_: All                 _u_: Mark read
_-_: Untag all             _T_: Today               _r_: Mark unread
_R_: Non reddit            _H_: Stuff               _B_: Blogs
"
    ("G" elfeed-search-fetch)
    ("Q" elfeed-search-quit-window "Quit Elfeed" :exit t)
    ("S" elfeed-search-set-filter)
    ("A" (elfeed-search-set-filter "@6-months-ago"))
    ("T" (elfeed-search-set-filter "@1-day-ago"))
    ("*" (elfeed-search-set-filter "@6-months-ago +star"))
    ("H" (elfeed-search-set-filter "+ai +healthcare"))
    ("B" (elfeed-search-set-filter "+blog"))
    ("R" (elfeed-search-set-filter "-reddit"))
    ("+" elfeed-search-tag-all)
    ("-" elfeed-search-untag-all)
    ("b" elfeed-search-browse-url)
    ("g" elfeed-search-update--force)
    ("n" next-line)
    ("C-n" next-line)
    ("p" previous-line)
    ("C-p" previous-line)
    ("r" elfeed-search-untag-all-unread)
    ("s" elfeed-search-live-filter)
    ("u" elfeed-search-tag-all-unread)
    ("y" elfeed-search-yank)
    ("RET" elfeed-search-show-entry)
    ("q" nil "quit" :exit t)
    ("C-g" nil "quit" :exit t))
  (bind-keys :map elfeed-search-mode-map
             ("h" . elfeed-hydra/body)
             ("?" . elfeed-hydra/body)))
