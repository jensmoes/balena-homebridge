# balena-homebridge
Homebridge installation using Balena
Uses provided `config.json` and `auth.json` files.
If you are using automated backup you can set an external location in `auto.smb`

Prep:
```
$ mkdir ../homebridge-config
$ cp <your auth.json and config.json> ../homebridge-config
```

Build:
```
$ balena push homebridge
```
