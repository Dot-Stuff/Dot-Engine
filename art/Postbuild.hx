package art;

import sys.io.*;
import sys.FileSystem;
import haxe.zip.*;
import haxe.crypto.Crc32;

using DateTools;

class Postbuild
{
    static function main()
    {
        trace('creating NG zip');
        var binFolder:String = 'export/release/html5/bin/';

        var date = Date.now();
        var outputName:String = 'NG-' + date.format("%Y%m%d--%H%M") + '.zip';

        var out = File.write(outputName);
        var zip = new Writer(out);
        zip.write(getEntries(binFolder));
        trace('Finished creating ZIP');
    }

    static function getEntries(dir:String, entries:List<Entry> = null, inDir:Null<String> = null)
    {
        if (entries == null)
            entries = new List<Entry>();
        if (inDir == null)
            inDir = dir;

        for (file in FileSystem.readDirectory(dir))
        {
            var path = Path.join([dir, file]);
            if (FileSystem.isDirectory(path))
                getEntries(path, entries, inDir);
            else
            {
                var bytes:Bytes = Bytes.ofData.ofData(File.getBytes(path).getData());
                var entry:Entry = {
                    fileName: StringTools.replace(path, inDir, ""),
                    fileSize: bytes.length,
                    fileTime: Date.now(),
                    compressed: false,
                    dataSize: FileSystem.stat(path).size,
                    data: bytes,
                    crc32: Crc32.make(bytes)
                };
                entries.push(entry);
            }
        }
    }
}