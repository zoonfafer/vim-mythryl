=============
 vim-mythryl
=============

Introduction
------------

``vim-mythryl`` provides:
        - Mythryl syntax highlighting for ``*.pkg`` and ``*.api`` files,
        - Mythryl script-oriented syntax highlighting for files that begin with 
          the shebang line (``#!.*\<mythryl\>``), and
        - **(deprecated)** Mythryl's ``make6`` syntax highlighting for 
          ``*.make6`` files [*]_ .
        - snipMate__ support for Mythryl.

.. [*] I have also included the match for ``*.standard`` files to be ``make6`` files, since I have seen files with such a suffix and they look like ``make6`` files.
__ http://github.com/msanders/snipmate.vim


Installation
------------

Just copy ``{ftplugin,indent,snippets,syntax}/*.vim`` and 
``ftdetect/mythryl.vim`` to ``~/.vim/``::

        $ cd vim-mythryl
        $ ls
        COPYING  ftdetect/  ftplugin/  indent/  README.rst  snippets/  syntax/
        $ cp -rut ~/.vim ftdetect/  ftplugin/  indent/  snippets/  syntax/
 


TODO
----

* Create indent file (**Help needed!  I don't know anything about auto-indenting for Vim.**) for Mythryl according to the `Coding Conventions <http://mythryl.org/my-Preface-11.html>`_
        - Indentation_ 
        - `Line stuff up`_
        - `Case expressions`_
        - `Record expressions`_
        - `Except statements`_
        - `Function definitions`_
        - `If statements`_
        - `?? ::`_
        - Commenting_
* **(deprecated)** Create indent file for ``make6``.
* Support the remaining syntax classes.
* Keep the syntax files clean and readable.

.. _Indentation: http://mythryl.org/my-Indentation.html
.. _Line stuff up: http://mythryl.org/my-Line_stuff_up.html
.. _Case expressions: http://mythryl.org/my-Case_expressions.html
.. _Record expressions: http://mythryl.org/my-Record_expressions.html
.. _Except statements: http://mythryl.org/my-Except_statements.html
.. _Function definitions: http://mythryl.org/my-Function_definitions.html
.. _If statements: http://mythryl.org/my-If_statements.html
.. _`?? ::`: http://mythryl.org/my-_____-2.html
.. _Commenting: http://mythryl.org/my-Commenting.html


Licence
-------

.. GNU General Public License version 3.  Copyright © 2010 ``vim-mythryl`` authors.  All Rights Reserved.


GNU General Public License version 3.
Copyright (c) 2010 ``vim-mythryl`` authors.  All Rights Reserved.

Please see the ``COPYING`` file provided with the source distribution for full 
details.


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
        
