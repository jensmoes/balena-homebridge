# balena-homebridge
Homebridge with Hubitat installation using Balena.
This seeks to minimize local filesystem writes to extend the lifetime of the SD card, but it's main purpose is to facilitate quick restoration when that cheap SD card eventually dies.
It installs various other packages that I like to use such as Haiku fan support.
Uses provided `config.json` and `auth.json` files, or input from environment/service variables.
If you are using automated backup you can set a network location in `auto.smb` to store them off device.

#Prep

To provide configuration tokens and authentication create them in the Balena Dashboard in the variables `CONFIG_JSON` and `AUTH_JSON` and paste in the JSON data.

If you wish to bake them into the image you can uncomment the `build-secrets` in `.balena/balena.yml` and do:
```
$ cp <your auth.json and config.json> .balena/secrets/
```
Don't forget to uncomment the `RUN` command in the `Dockerfile` to actually copy over the files at build time.
They will then be added to the image.
Note: The environment variables will override any build time configuration.

# Build

```
$ balena push homebridge
```

# Upgrade

To upgrade any of the packages push with the `nocache` option.
```
$ balena push --nocache homebridge
```
