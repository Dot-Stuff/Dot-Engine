package mods;

import firetongue.FireTongue;
import polymod.format.ParseRules.TextFileFormat;
import polymod.Polymod;

using StringTools;

class ModHandler
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
		loadConfiguredMods();
	}

	/**
	 * Loads configured mods
	 */
	public static function loadConfiguredMods()
	{
		trace('User mod config: ${getConfiguredMods()}');
		loadModsById(getConfiguredMods());
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
			framework: OPENFL,
			// The current version of our API.
			apiVersion: API_VERSION,
			// Call this function any time an error occurs.
			errorCallback: onPolymodError,
			// Enforce semantic version patterns for each mod.
			// modVersions: null,
			// A map telling Polymod what the asset type is for unfamiliar file extensions.
			// extensionMap: [],

			frameworkParams: buildFrameworkParams(),

			// List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
			ignoredFiles: Polymod.getDefaultIgnoreList(),

			// Parsing rules for various data formats.
			parseRules: buildParseRules(),

			// Pass FireTongue into Polymod
			firetongue: LocaleHandler.tongue
		});
	}

	public static function getAllMods():Array<ModMetadata>
	{
		var modMetadata = Polymod.scan(MOD_DIRECTORY);
		// trace('${modMetadata.length} Mods were scanned');
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
		// Ensure scripts have merge support.
		output.addType("hxs", TextFileFormat.PLAINTEXT);

		return output;
	}

	static inline function buildFrameworkParams():polymod.FrameworkParams
	{
		return {
			assetLibraryPaths: [
				"default" => "./preload", "locales" => "./locales", "scripts" => "./scripts", "songs" => "./songs", "shared" => "./", "stage" => "./stage",
				"spooky" => "./spooky", "philly" => "./philly", "limo" => "./limo", "mall" => "./mall", "mall-evil" => "./mall-evil", "school" => "./school",
				"school-evil" => "./school-evil", "tank" => "./tank"
			]
		}
	}

	static function onPolymodError(error:PolymodError)
	{
		if (error.code == MISSING_ICON)
			trace('[POLYMOD] A mod is missing an icon, will just skip it but please add one: ${error.message}');
		else
			trace('[POLYMOD] ${error.message}');
	}
}
