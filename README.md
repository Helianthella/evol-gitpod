# Gitpod env for The Mana World &nbsp; [![Open in Gitpod](https://img.shields.io/badge/Gitpod-ready-blue?logo=gitpod)](https://gitpod.io/#https://github.com/Helianthella/evol-gitpod)

Creates a new Gitpod instance pre-configured for The Mana World.

> ⚠️ **This is a Work in Progress**: This dev environment is not quite ready for prime time yet.
  This repo will be moved to the TMW namespace once it is considered stable and suitably tested.

## Components
- Evol [server-data](https://gitlab.com/evol/serverdata), [client-data](https://gitlab.com/evol/clientdata), and [tools](https://gitlab.com/evol/evol-tools)
- [Hercules](https://gitlab.com/evol/hercules) & [Evol-Hercules](https://gitlab.com/evol/evol-hercules) (plugin)
- [ManaPlus](https://gitlab.com/manaplus/manaplus)
- [seppuku](https://github.com/Helianthella/seppuku) (zsh prompt)
- noVNC (to run ManaPlus)

## Configuration
Environment variables may be set in the Gitpod account settings to configure the environment.

- `GITHUB_NAME`: your GitHub username
- `GITLAB_NAME`: your GitLab username
- `GIT_AUTHOR_NAME`: the author name to use whit git
- `GIT_AUTHOR_EMAIL`: the author email to use whit git
