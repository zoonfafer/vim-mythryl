=============
 vim-mythryl
=============

Introduction
------------

``vim-mythryl`` provides:
        - Mythryl syntax highlighting for ``*.pkg``, ``*.api`` and ``*.my`` [*]_ files , and
        - Mythryl's ``make6`` syntax highlighting for ``*.make6`` files.

.. [*] Please note that ``.my`` is *not* an official suffix for a Mythryl script!


Installation
------------

Just copy ``syntax/*.vim`` and ``ftdetect/mythryl.vim`` to ``~/.vim/``::

        $ cd vim-mythryl
        $ ls
        COPYING  ftdetect/  syntax/  README.rst
        $ cp -rt ~/.vim ftdetect/ syntax/


TODO
----

- create "indent" files for Mythryl and ``make6``.
- "complete" the syntax highlighting...


License
-------

GPLv3. Copyright (c) 2010 vim-mythryl authors.

See the ``COPYING`` file provided with the source distribution for full details.


Authors
-------

- Jeffrey Lau <vim@NOSPAMjlau.tk>


Credits
-------

- Thanks to `Cynbe ru Taren`__ for creating the `Mythryl`__ language. (`github page`__)

__ http://muq.org/~cynbe/
__ http://mythryl.org
__ http://github.com/mythryl/mythryl


See Also
--------

- `mythryl-mode`__ for Emacs by Phil Rand.

__ http://github.com/phr/mythryl-mode
        

