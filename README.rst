=============
 vim-mythryl
=============

Introduction
------------

``vim-mythryl`` provides:
        - Mythryl syntax highlighting for ``*.pkg``, ``*.api``, ``*.my``  and ``*.mythryl`` [*]_ files , and
        - Mythryl's ``make6`` syntax highlighting for ``*.make6`` [*]_ files.


Installation
------------

Just copy ``syntax/*.vim`` and ``ftdetect/mythryl.vim`` to ``~/.vim/``::

        $ cd vim-mythryl
        $ ls
        COPYING  ftdetect/  syntax/  README.rst
        $ cp -rt ~/.vim ftdetect/ syntax/



Licence
-------

GNU General Public License version 3. Copyright (c) 2010 ``vim-mythryl`` authors.

Please see the ``COPYING`` file provided with the source distribution for full details.


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
        

.. [*] Please note that ``.my`` and ``.mythryl`` are *not* official suffixes for a Mythryl script!
.. [*] I have also included the match for ``*.standard`` files to be ``make6`` files, since I have seen files with such a suffix and they look like ``make6`` files.
