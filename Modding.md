# Modding | Getting Started Guide
Lets get started on the basics
First, make a new folder in `mods`. Make sure to name it your mod's name. Then, create a `_polymod_meta.json` include this structure. You can add a `_polymod_icon.png` it's not mandatory.
```json
{
    "title": "Your New Mod",
    "description": "Your Mod's Description",
    "author": [
        {
            "name": "Your Name",
            "role": "Your Role"
        }
    ],
    "api_version": "0.1.0",
    "mod_version": "1.0.0-alpha",
    "license": "Apache License 2.0"
}
```

## Appending and Merging.
- Appending to add onto the data
- Merging to combine two files. There's a different way of merging file types XML, JSON, etc. [Read more here.](https://polymod.io/docs/merging-files/)
