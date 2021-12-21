package mods;

import polymod.backends.OpenFLBackend;
import polymod.format.ParseRules.TextFileFormat;
import polymod.Polymod;

@:hscript({
    context: [Std, Math]
})
interface HScript extends polymod.hscript.HScriptable
{
}

class Modding
{
	static final API_VERSION = "0.1.0";

	static final MOD_DIRECTORY = "mods";

	public static function init()
	{
        loadModsById(getModIds());
	}

	public static function loadModsById(ids:Array<String>)
	{
		polymod.Polymod.init({
			// Root directory for all mods.
			modRoot: MOD_DIRECTORY,
			// The directories for one or more mods to load.
			dirs: ids,
			// Framework being used to load assets. We're using a CUSTOM one which extends the OpenFL one.
			framework: CUSTOM,
			// The current version of our API.
			apiVersion: API_VERSION,
			// Enforce semantic version patterns for each mod.
			// modVersions: null,
			// A map telling Polymod what the asset type is for unfamiliar file extensions.
			// extensionMap: [],

			frameworkParams: buildFrameworkParams(),

			// Use a custom backend so we can get a picture of what's going on,
			// or even override behavior ourselves.
			customBackend: OpenFLBackend,

			// List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
			ignoredFiles: Polymod.getDefaultIgnoreList(),

			// Parsing rules for various data formats.
			parseRules: buildParseRules(),
		});
	}

	static function getModIds():Array<String>
	{
		var modMetadata = Polymod.scan(MOD_DIRECTORY);
		var modIds = [for (i in modMetadata) i.id];
		return modIds;
	}

	static function buildParseRules():polymod.format.ParseRules
	{
		var output = polymod.format.ParseRules.getDefault();
		// Ensure TXT files have merge support.
		output.addType("txt", TextFileFormat.LINES);

		return output;
	}

	static inline function buildFrameworkParams():polymod.FrameworkParams
	{
		return {
			assetLibraryPaths: [
				"default" => "./preload",
				"scripts" => "./scripts",
				"songs" => "./songs",
				"shared" => "./",
				"tutorial" => "./tutorial",
				"week1" => "./week1",
				"week2" => "./week2",
				"week3" => "./week3",
				"week4" => "./week4",
				"week5" => "./week5",
				"week6" => "./week6",
				"week7" => "./week7"
			]
		}
	}
}
