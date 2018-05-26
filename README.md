# Huntpad

Huntpad is a notepad application with features that are particularly useful to penetration testers and bug hunters - a collection of common injection string generators, hash generators, encoders and decoders, HTML and text manipulation functions, and so on, coupled with syntax highlighting for several programming languages. For more details, visit the [Huntpad homepage](http://www.syhunt.com/en/?n=Products.SyhuntHuntpad).

## Directories

* `/lualib` - the source of the Huntpad Forge Lua library containing many of its toolbar functions written in a variety of languages. 
* `/packs` - contents of the uncompressed pack file *Huntpad.scx*
* `/src` - the main executable source and built-in resource files
 * `/html` - user interface resources (HTML)
 * `/lua` - Lua API source

## Download

Compiled binaries for Windows can be downloaded from the links below.

* [1.0.2 32-bit](http://www.syhunt.com/en/index.php?n=Tools.DownloadHuntpad)

## Compiling

For compiling Huntpad, you will just need [Catarinka](https://github.com/felipedaragon/catarinka) and [pLua](https://github.com/felipedaragon/pLua-XE).
 
There is no need to install third-party components in the IDE - you can just add the dependencies listed above to the library path and hit compile. It compiles under Delphi 10 Seattle down to XE2.

When starting up, Huntpad will require the [Underscript](https://github.com/felipedaragon/underscript) Lua library compiled and some packed resource files from [Sandcat](https://github.com/felipedaragon/sandcat) (*Common.pak* and *Resources.pak*) to work.

## License & Credits

Huntpad was developed by Felipe Daragon, [Syhunt](http://www.syhunt.com/).

This code is licensed under a 3-clause BSD license - see the LICENSE file for details.

Third-party software used in Huntpad include:

* [Lua](http://www.lua.org/) - Developed by a small team at Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio), Lua is a core language used by Huntpad.
* **Sciter** is the engine currently used by Huntpad for rendering its user interface toolbar.
* Icons are derived from: [Fugue Icons](https://github.com/yusukekamiyamane/fugue-icons) (by [@yusukekamiyamane](https://github.com/yusukekamiyamane/)) and [FatCow Icons](http://www.fatcow.com/free-icons).
* For syntax highlighting, Huntpad currently uses [SynEdit](http://sourceforge.net/projects/synedit/) and [@Krystian-Bigaj](https://github.com/Krystian-Bigaj)'s [SynWeb](https://code.google.com/p/synweb/) with a color scheme adapted from [@korny](https://github.com/korny)'s [CodeRay](https://github.com/rubychan/coderay).

The license for each component listed above can be found in the `/packs/Resources/docs/` directory of the [Sandcat](https://github.com/felipedaragon/sandcat) repository.

## Contact

Twitter: [@felipedaragon](https://twitter.com/felipedaragon), [@syhunt](https://twitter.com/syhunt)

Email: felipe _at_ syhunt.com