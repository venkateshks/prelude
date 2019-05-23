(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (google-contacts smtpmail-multi emms ensime elfeed jupyter ein ob-ipython google-c-style scala-mode transient git-gutter cmake-ide cmake-font-lock cmake-mode ccls webpaste all-the-icons-dired all-the-icons paradox wiki-summary thrift dap-java cquery multiple-cursors org-jira treemacs dap-mode lsp-java pyvenv lsp-python company-lsp lsp-ui lsp-mode pipenv use-package ess eyebrowse vlf tabbar-ruler tabbar company-jedi lispy ggtags imenu-list yaml-mode web-mode cider clojure-mode helm-ag helm-descbinds key-chord helm-projectile helm anaconda-mode ripgrep markdown-mode exec-path-from-shell zop-to-char zenburn-theme which-key volatile-highlights undo-tree smartrep smartparens smart-mode-line operate-on-number move-text magit projectile imenu-anywhere hl-todo guru-mode grizzl god-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region epl editorconfig easy-kill diminish diff-hl discover-my-major crux browse-kill-ring beacon anzu ace-window)))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 25))
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
          ("https://rafay.co/feed/" startups blog)
          ("https://news.ycombinator.com/rss" startups blog)
          ("https://lars.ingebrigtsen.no/feed/" emacs blog)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UChvithwOECK5g_19TjldMKw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCZPqG0yh_xPm2AyLjffbDvw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCstt9_SJ74c5fEOICaUUlrA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCRL9jNF5eKw2sdYPf6pCYjA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmfZzZFv9iJ0_U8zbr1ShFw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCep7Sas3MA_N1tARdn5Chhg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCnI3TuOg8D3SCRPW8ET4EAg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbuteaQuzn_pcd_OctvPn6w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCnP-1WkDyKRpnFmtiYJEiog" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC6s-1TYa-1fBrUUIGijshCQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCe43pe3w4L6w3tNMRkWiJBA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCxXMLRMzWsbgq4hZn5Ce_PA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCyoXW-Dse7fURq30EWl_CUA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCX_uPA_dGf7wXjuMEaSKLJA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCaThRBMEp21yRK4seqq3-Sw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCpNzIilOKJVR8YcP9XKmylw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCn2AasLKAJwJ7GRb161cJ8g" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC8uT9cgJorJPWu7ITLGo9Ww" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCJ24N4O0bP7LGLBDvye7oCA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmvUCGX9p6-azd2AetDRI8A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCyKcY3yMOqhUURRozLHQsvw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCidJftClM4kU1196YynvqXg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCjwffQsTawRrpYNAHpTVakQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC-V6odR7HzLCuqjYeowPjLA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCgAYWS3ldZMhsBpXi6kn2Yw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCJvrv6Taq5P3nk9hez_Y1eA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC5IhSDXTsi6TrIGHiW8kIBg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCpcdPloTijprixyP0as7sDg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC5__yPPM1jbGAnh6VMtXG7Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2fqia0S__5mBCrOiaPgj4A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCXorcr7Q0vtCLlLMIA4K4gA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCrR6VmLjCIFSryAkIUt_0lQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCMadvcf6e_cVUTuO8EShybw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCOeUnUZ4zuWX4yBYAT5OaAQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCoxBqa1BQr-3Bzb1QNB0_uQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmTH6Cz_j8eYq8oiOHDoTXg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCCifAOOTAgclGm2f_TDGC7A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCWPzT9H7dH5i7FaI9-BuUmA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCScHdYFS_KBduqkRBjbQNuA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC1AKDrz2GvLxD29W9tow66g" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCnR_8DU5JCG0y95uI_5ynPw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCtinbF-Q-fVthA0qrFQTgXQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC6ro_Y4qzUrajH4oAiW1Nqw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCC-SRrKJyVws2N6xsWRkNXg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCdbe7oVsJTRN7sgwnVy4GIg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC1LU8rvHLxjDjyvym57EDtA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbBVRJq3H6yRvC9G6xBLJZw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCZqacx-IBQKcyLBExQ0k_CA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC88A5W9XyWx7WSwthd5ykhw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCP4KzKSab2jurSgfEhYcCiQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3vFznWAkGITMT2clmgwOaA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCdI5i_U9v6yfYsBu8R84TOA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCh_w_vLvlZNBeTAP8qaWhoA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCVptfwYcLxRED8w4Efy0CsA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCAf9vHS_4I9lSu-7gYhkzaw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCVYY9eVVjh5Y7J4ztBma-kw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCfFxQGZayreZipbO0EcxvfQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC-oku1_VvM3cA6VC4PBKmAA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_EBxa1iMFqlGwxZDl9dwuQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCYFSvWiRyieH1GGzK-WYJlA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_GiI83OPF1cwYlT9wUpMBw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCnQS0hHNi2XCPKmkuhLomdA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCj0V0aG4LcdHmdPJ7aTtSCQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCNCtWKts-e2hhF-_ojm7zUQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCEBjuHm_Z6hz8Q6C_dm8bSg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCdt2o-hQ3BF-lc1z58ZY2mw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqMvc08a5EUZDCgUd6K6yCQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCoo0wb-sHBq5rZ6LaC2aY1Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqGdsSAJluuxx0ol3eDKVYQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCpyhJZhJQWKDdJCR07jPY-Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCFYfMePrv9Z8AZeGSqhEt8Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqYPhGiB9tkShZorfgcL2lA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCSxqXJj9btSS3nrmBg8GXdQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPoczsTDKh_CJvWWLKKUmwA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCAL3JXZSzSm8AlZyD3nQdBA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC03j2jcKwm0wTJpDsu-9u4g" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCF0Hu5gXcvEJEGgdRy6bhBQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCRsf9Da0DwxMFds-RwY6R_A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCzRYivTpUQ0r2qPPjfLoQiA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3SYvSmzvsDERtmB7QD_iJw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCZIIRX8rkNjVpP-oLMHpeDw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCz9u5jdtxEoMHEWfCmVFWTg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2mNCHWMsOFsieQuw4jdZTQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCjGZ6D8hJFvLur5K_p9vKAA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCZ9rtgneFVp0wiQWQedaShw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCiggzUQ0UKd4mDWub4C3Fiw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC083mi1sPEKkXB6ye7VaRPg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCZ7rYtyjSgF1jMYHCkyjwMQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC0RpYq2S56n4y2xQB9RlrJA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCb75CvYbm5BXpbEkGqFKABw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCHciM8wE8UYy0tTiRWI9bTA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3w193M5tYPJqF0Hi-7U-2g" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCa3ia1bE4EOt__vJ6lnpLeQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqA1KASrQLjLVNK9KnFKxFQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCMDV6J2hWXet7ZCfgrXGgeg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCGRIgtqal_cC7V_cD-Zylkg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCoOQXbrTGLzXXEhShx5mzMg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCXM2ne7ePM767NFKdizAHMg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCMpZ_fKWmTeZEOLy9PFfFxg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCcHViSTz5L_C7n0KEkPB7sQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCrN1lcGgsCB9axGjZjpOqiQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCHcRjWV5XOGdYkM7ruvpgxw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqCsLoMey5cfMH64CuQjC7g" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCiAq_SU0ED1C6vWFMnw8Ekg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC9-EE_9NTDDW0lHad0YOlzQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCiiXTX1KmB9-kSlaUckeXDA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UClZkHt2kNIgyrTTPnSQV3SA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCwNPa8fSXzzAZuT9859GVhg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCOTrRnxBOllb9UHLuap_lPg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCicjynhfFw2LiIQFnoS1JTw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_3vfVLGjww6N6ZudokdGvw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC8EQAfueDGNeqb1ALm0LjHA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCTzLRZUgelatKZ4nyIKcAbg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCJzYsXrglBxspBZg8nGvp-Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC9fSZHEh6XsRpX-xJc6lT3A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCl7mAGnY4jh4Ps8rhhh8XZg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_7aK9PpYTqt08ERh1MewlQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC1MwJy1R0nGQkXxRD9p-zTQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UClgRkhTL3_hImCAmdLfDE4g" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCetlaEo5ywcDU4GMt9kdJ4w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCdXZL_XkP14WU7CV296LiKw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCTAe61eqoK0G3gcmBDa754w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCckETVOT59aYw80B36aP9vw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCnf609gsCjoJd_GvQ31SFVA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_5Xhfmz-KE3VyVuhwJ57hw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCjWs7BxyjO5SLqevxSmp4vQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbR6jJpva9VIIAHTse4C3hw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCJdKr0Bgd_5saZYqLCa9mng" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UChtY6O8Ahw2cz05PS2GhUbg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqbFWAfeuLgn8m81rUL4ghQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCcefcZRL2oaA_uBNeo5UOWg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC12fgojXZONDxfbBC4Qnffg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCaLlzGqiPE2QRj6sSOawJRg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCE7GmAYeBVgqDItdX2ihuHQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCzUYuC_9XdUUdrnyLii8WYg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCiTVZa6InO6COnn83fITbwQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCnnZ0fKQpHWov3sjUax1MDw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCSiU-lsiTvPHDVX7ctVCprA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC0o8xq4i4v5VTvL1f9wcxPQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCzYMTUy7uWCfaoBX0tPJE5A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmyPr7TbvE9ycl9PL-UiA5A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCMr12AHjiyPaAhfKjsVLNAA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC27nqmEhKzD9YHK1IFwG7qA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCRv76wLBC73jiP7LX4C3l8Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCyEd6QBSgat5kkC6svyjudA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCdC3h2m88FC02Yw-A_VESRQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsTcErHg8oDvUnTzoqsYeNw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCXGgrKt94gR6lmN4aN3mYTg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCEhGzFzSaf_js4wfGVcHKKA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCu59yAFE8fM0sVNTipR4edw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCwAMahiZ4RQb3i6BdQ1cOGA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UClT2UAbC6j7TqOWurVhkuHQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCDlQwv99CovKafGvxyaiNDA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCJyD6to7nmJsLzWi8X2N_Pg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCAeR_WZMM_-tb1jGZIcqjkg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCHYK2TMQzKbx9BmGLPdCj3w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCcbZ6rsKJ7ie5EvFmqHqfZw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCoNTMWgGuXtGPLv9UeJZwBw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3djj8jS0370cu_ghKs_Ong" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCDLl_-lfEBsXw0EbVkhKviQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCQCV_2mN0iHzwGRFjbsszBw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCBnZ16ahKA2DZ_T5W0FPUXg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCLxWPHbkxjR-G-y6CVoEHOw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCAezwIIm1SfsqdmbQI-65pA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCAapLx9Jr4aClLgkrFRTZAQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCzKWILdrVl8ZEcDzaH4kl_A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCoYe2YOpqspuGAOB1Epe7GA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCiHTqyILO4CRHeJRorlyhow" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCU_AsfgtKjwR4qaSwgsWn-w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCMkhrrPkmx7xxlolSP9qEsA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCzNAswnSN0rZy79clU-DRPg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCI4I6ldZ0jWe7vXpUVeVcpg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_x5XG1OV2P6uZZ5FSM9Ttw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC4gON4eBraggD3DiO3ttlIg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCtXKDgv1AVoG88PLl8nGXmw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCcAtD_VYwcYwVbTdvArsm7w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCiLF4eSar8tLEu5er8E9JnQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC49es_lxv6UyHtXyvpcd_rw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCW6J17hZ_Vgr6cQgd_kHt5A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCQlC9iwSZ2a0-96RLleG_xg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCDsElQQt_gCZ9LgnW-7v-cQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCRHfNta2Fa4jlxwCMIdvDQA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC4QZ_LsYcvcq7qOsOhpAX4A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCBJycsmduvYEL83R_U4JriQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3s0BtrBJpwNDaflRSoiieQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCXzySgo3V9KysSfELFLMAeA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC5I2hjZYiW9gZPVkvzM8_Cw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCRAxVOVt3sasdcxW343eg_A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqKjRzvYd2QmW-Pa-VNCZSQ" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCNJP0oF6k62xA_qhCLfwI-Q" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCaqcvH8EvUtePORpN03jLMg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCkRmQ_G_NbdbCQMpALg6UPg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UClmUI0PnpT5q_B4TsGNtOAg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCTP1DN8Us94z0ciuCx71scg" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCjTCFFq605uuq4YN4VmhkBA" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCO2x-p9gg9TLKneXlibGR7w" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCd-EhXGbXSozuzsAAdPIn3A" youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UClJshc6QtMWRqIAwJy85sfA" youtube)
          ))


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
