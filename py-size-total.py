import os
import fnmatch
size= 0
for path, dirs, files in os.walk( '.' ):
    for f in files:
        if fnmatch.fnmatch(f,'*'):
            fileSize= os.path.getsize( os.path.join(path,f) ) 
#            print f, fileSize
            size += fileSize
print size/1024/1024/1024
