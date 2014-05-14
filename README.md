Haskell Platform 2011.2 is required.  Test installer is available here:

    http://projects.haskell.org/pipermail/haskell-platform/2011-February/001400.html

Demo
--------

Please type "make demo" to see a worked example of localizing RT4 with myGengo using po2txt/txt2po.
A sample run would look like this:

### Step 1: Turn .po file into new and reference .txt files
    runghc po2txt.hs demo/zh_CN.po
    *** Written TXT file: demo/zh_CN.po.new.txt
    *** Written TXT file: demo/zh_CN.po.ref.txt

### Step 2: Send zh_CN.po.new.txt to myGengo Translate API...
###        (with zh_CN.po.ref.txt included in comment as reference)

### Step 3: Received RequestTracker-zh_CN.txt from myGengo;
###         convert it back to .po format
    runghc txt2po.hs demo/RequestTracker-zh_CN.txt
    *** Written PO file: demo/RequestTracker-zh_CN.txt.po

### Step 4: Run msgmerge to merge new translations with old ones
    msgmerge -N --previous -s --no-wrap demo/RequestTracker-zh_CN.txt.po demo/zh_CN.po > demo/merged-zh_CN.po
    ................................................................................................................................................................................................................................................................................... 完成。

### All Done! See demo/merged-zh_CN.po for the final output.


Build
-----
To build `po2txt`/`txt2po` as binary, simply run:

    make bin

`po2txt` and `txt2po` will be built in the `bin` directory.
