# 👋🏻 Welcome, fellow Geek! ❤️

- [👋🏻 Welcome, fellow Geek! ❤️](#-welcome-fellow-geek-️)
- [🙋‍♂️ What is this?](#️-what-is-this)
- [How do I use this?](#how-do-i-use-this)
  - [Docker Swarm + Ansible (automatically) 🐳 + 🦾](#docker-swarm--ansible-automatically---)
  - [Docker Swarm Manually (the old way) 👴🏻](#docker-swarm-manually-the-old-way-)
- [FAQ](#faq)
  - [Where to go for help?](#where-to-go-for-help)
  - [How do I request a recipe?](#how-do-i-request-a-recipe)
  - [Can I contribute fixes etc?](#can-i-contribute-fixes-etc)
  - [Bootstrap flux](#bootstrap-flux)

# 🙋‍♂️ What is this?

This is the "premix" for [Funky Penguin's Geek Cookbook](https://geek-cookbook.funkypenguin.co.nz), and is intended to "fast-track" deployment of the [Docker Swarm](https://geek-cookbook.funkypenguin.co.nz/docker-swarm/) / [Kubernetes](https://geek-cookbook.funkypenguin.co.nz/kubernetes/) recipes, in an opinionated fashion.

The premix was originally sponsors-only, but was opened up (*[duplicated-in-a-public-repo](https://trufflesecurity.com/blog/anyone-can-access-deleted-and-private-repo-data-github), really*), to foster community involvement (*and because your geek-chef got busy cooking [ElfHosted](https://elfhosted.com), an open-source "geek-cookbook-as-a-service" platform!*).

The repository includes:
* Standard docker-compose files for each recipe in the cookbook
* Ansible playbooks for automatically deploying the entire stack plus popular/current recipes

# How do I use this?

## Docker Swarm + Ansible (automatically) 🐳 + 🦾 

Detailed instructions are available [here](https://geek-cookbook.funkypenguin.co.nz/premix/ansible/operation/).

## Docker Swarm Manually (the old way) 👴🏻

1. At a high level, ```git pull git@github.com:funkypenguin/geek-cookbook-premix.git /var/data/config```.
2. For each recipe, edit the .yml and replace my config (data paths, `example.com` domain name, etc) with yours
3. Where a ```<recipe name>.env-sample``` exists, rename this to ```<recipe-name>.env```, and customize

# FAQ

## Where to go for help?

1. The [Discord chat](http://chat.funkypenguin.co.nz) for realtime (*but non-persistent*) support
2. The [Funky Penguin's Geek Forums](https://forum.funkypenguin.co.nz/), to trawl through previous support/discussions

## How do I request a recipe?

Create an issue, a template is waiting to help you identify the required details

## Can I contribute fixes etc?

Of course! Submit a PR, we'll go from there!

## Bootstrap flux

Create personal token at https://github.com/settings/tokens, Create a GitHub personal access token that can create repositories by checking all permissions under repo, as well as all options under admin:public_key

Save the token to your ansible vault, as github_flux_token