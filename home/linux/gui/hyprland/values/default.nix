{configLib, ...} @ args:
map
(path: import path args)
(configLib.scanPaths ./.)
