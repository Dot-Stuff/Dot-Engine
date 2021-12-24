package mods;

import polymod.backends.OpenFLBackend;
import polymod.format.ParseRules.TextFileFormat;
import polymod.Polymod;

using StringTools;

class Modding
{
	/**
	 * Semantic Versioning v2; <MAJOR>.<MINOR>.<PATCH>.
	 */
	static final API_VERSION = "0.1.0";

	static final MOD_DIRECTORY = "mods";

	/**
	 * Loads all mods
	 * Saves the mods as well
	 */
	public static function init()
	{
		var modIds = getAllModIds();

        loadModsById(modIds);
		createSaveData(modIds);
	}

	/**
	 * Loads configured mods
	 */
	public static function loadConfiguredMods()
	{
		trace('User mod config: ${FlxG.save.data.modConfig}');
		loadModsById(getConfiguredMods());
	}

	/**
	 * TODO: Make this save data and not a static var
	 */
	public static function createSaveData(modIds:Array<String>)
	{
		//loadedMods = modIds;
	}

	/**
	 * The user's configured order of mods to load.
	 * @return The mod order to load
	 */
	public static function getConfiguredMods():Array<String>
	{
		var rawSaveData = FlxG.save.data.modConfig;

		if (rawSaveData != null)
			return rawSaveData.split('~');

		return null;
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
			// Call this function any time an error occurs.
			errorCallback: onPolymodError,
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

	public static function getAllMods():Array<ModMetadata>
	{
		var modMetadata = Polymod.scan(MOD_DIRECTORY);
		//trace('${modMetadata.length} Mods were scanned');
		return modMetadata;
	}

	public static function getAllModIds():Array<String>
	{
		var modIds = [for (i in getAllMods()) i.id];
		return modIds;
	}

	static function buildParseRules():polymod.format.ParseRules
	{
		var output = polymod.format.ParseRules.getDefault();
		// Ensure TXT files have merge support.
		output.addType("txt", TextFileFormat.LINES);
		// Ensure script files have merge support.
		output.addType("hxs", TextFileFormat.PLAINTEXT);

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

	static function onPolymodError(error:PolymodError)
	{
		if (error.code == MISSING_ICON)
			trace('A mod is missing an icon, will just skip it but please add one: ${error.message}');
		else
			trace(error.message);
	}
}
