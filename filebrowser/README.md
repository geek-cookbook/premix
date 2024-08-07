# What is this?

FileBrowser is...  a web-based file browser (surprised?) - for details, see https://filebrowser.github.io

# Why do I need it?

It lets you provide a web-based UI to manage a folder structure, even a set of docker-swarm configs ;)

# How does it work?

Browse the provided volume from the containers host.

The folder that is mapped is the volume from the yml, which is bound to /srv

# How to use it?

Make your data directory:
```
mkdir /var/data/runtime/filebrowser
```

Copy the provided config.json to the /var/data/config/filebrowser folder.

Launch the stack, and then browse to https://filebrowser.<your domain>. Default credentials are admin/admin

This recipe is mainly a @gkoerk recipe just adapted to use the folder structure of the funkypenguin's one
