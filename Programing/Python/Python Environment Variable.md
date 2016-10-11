# Python环境变量
下面几个重要的环境变量，它应用于Python：

|变量名|	描述|
| --- | --- |
|PYTHONPATH		|PYTHONPATH是Python搜索路径，默认我们import的模块都会从PYTHONPATH里面寻找。|
|PYTHONSTARTUP	|Python启动后，先寻找PYTHONSTARTUP环境变量，然后执行此文件中变量指定的执行代码。|
|PYTHONCASEOK	|加入PYTHONCASEOK的环境变量, 就会使python导入模块的时候不区分大小写.|
|PYTHONHOME	|另一种模块搜索路径。它通常内嵌于的PYTHONSTARTUP或PYTHONPATH目录中，使得两个模块库更容易切换。|

官方介绍：

PYTHONHOME
Change the location of the `standard Python libraries`. By default, the libraries are searched in prefix/lib/pythonversion and exec_prefix/lib/pythonversion, where prefix and exec_prefix are installation-dependent directories, both defaulting to /usr/local.

When PYTHONHOME is set to a single directory, its value replaces both prefix and exec_prefix. To specify different values for these, set PYTHONHOME to prefix:exec_prefix.

PYTHONPATH
Augment `the default search path for module files`. The format is the same as the shell’s PATH: one or more directory pathnames separated by os.pathsep (e.g. colons on Unix or semicolons on Windows). Non-existent directories are silently ignored.

In addition to normal directories, individual PYTHONPATH entries may refer to zipfiles containing pure Python modules (in either source or compiled form). Extension modules cannot be imported from zipfiles.

The default search path is installation dependent, but generally begins with prefix/lib/pythonversion (see PYTHONHOME above). It is always appended to PYTHONPATH.

An additional directory will be inserted in the search path in front of PYTHONPATH as described above under Interface options. The search path can be manipulated from within a Python program as the variable sys.path.

PYTHONSTARTUP
If this is the name of a readable file, the Python commands in that file are executed before the first prompt is displayed in interactive mode. The file is executed in the same namespace where interactive commands are executed so that objects defined or imported in it can be used without qualification in the interactive session. You can also change the prompts sys.ps1 and sys.ps2 in this file.
PYTHONY2K
Set this to a non-empty string to cause the time module to require dates specified as strings to include 4-digit years, otherwise 2-digit years are converted based on rules described in the time module documentation.
PYTHONOPTIMIZE
If this is set to a non-empty string it is equivalent to specifying the -O option. If set to an integer, it is equivalent to specifying -O multiple times.
PYTHONDEBUG
If this is set to a non-empty string it is equivalent to specifying the -d option. If set to an integer, it is equivalent to specifying -d multiple times.
PYTHONINSPECT
If this is set to a non-empty string it is equivalent to specifying the -i option.

This variable can also be modified by Python code using os.environ to force inspect mode on program termination.

PYTHONUNBUFFERED
If this is set to a non-empty string it is equivalent to specifying the -u option.
PYTHONVERBOSE
If this is set to a non-empty string it is equivalent to specifying the -v option. If set to an integer, it is equivalent to specifying -v multiple times.
PYTHONCASEOK
If this is set, Python ignores case in import statements. This only works on Windows.
PYTHONDONTWRITEBYTECODE
If this is set, Python won’t try to write .pyc or .pyo files on the import of source modules.

New in version 2.6.

PYTHONIOENCODING
Overrides the encoding used for stdin/stdout/stderr, in the syntax encodingname:errorhandler. The :errorhandler part is optional and has the same meaning as in str.encode().

New in version 2.6.

PYTHONNOUSERSITE
If this is set, Python won’t add the user site-packages directory to sys.path.

New in version 2.6.

See also PEP 370 – Per user site-packages directory
PYTHONUSERBASE
Defines the user base directory, which is used to compute the path of the user site-packages directory and Distutils installation paths for python setup.py install --user.

New in version 2.6.

See also PEP 370 – Per user site-packages directory
PYTHONEXECUTABLE
If this environment variable is set, sys.argv[0] will be set to its value instead of the value got through the C runtime. Only works on Mac OS X.
PYTHONWARNINGS
This is equivalent to the -W option. If set to a comma separated string, it is equivalent to specifying -W multiple times.
1.2.1. Debug-mode variables
Setting these variables only has an effect in a debug build of Python, that is, if Python was configured with the --with-pydebug build option.

PYTHONTHREADDEBUG
If set, Python will print threading debug info.

Changed in version 2.6: Previously, this variable was called THREADDEBUG.

PYTHONDUMPREFS
If set, Python will dump objects and reference counts still alive after shutting down the interpreter.
PYTHONMALLOCSTATS
If set, Python will print memory allocation statistics every time a new object arena is created, and on shutdown.
