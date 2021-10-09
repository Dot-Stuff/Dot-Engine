@echo off
haxe -main SongConverter.hx --cs export/songShit
@echo on
echo The exe directory is %cd%\export\songShit\bin\SongConverter.exe
@pause