=============
 vim-mythryl
=============

Introduction
------------

``vim-mythryl`` provides:
        - Mythryl syntax highlighting for ``*.pkg``, ``*.api``, ``*.my``  and ``*.mythryl`` [*]_ files , and
        - Mythryl's ``make6`` syntax highlighting for ``*.make6`` [*]_ files.


.. [*] Please note that ``.my`` and ``.mythryl`` are *not* official suffixes for a Mythryl script!
.. [*] I have also included the match for ``*.standard`` files to be ``make6`` files, since I have seen files with such a suffix and they look like ``make6`` files.


Installation
------------

Just copy ``syntax/*.vim`` and ``ftdetect/mythryl.vim`` to ``~/.vim/``::

        $ cd vim-mythryl
        $ ls
        COPYING  ftdetect/  syntax/  README.rst
        $ cp -rt ~/.vim ftdetect/ syntax/


Authors
-------

- Jeffrey Lau <vim@NOSPAMjlau.tk>


