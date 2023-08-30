# qb-multicharacter
Multi Character Feature for QB-Core Framework :people_holding_hands:

Added support for setting default number of characters per player per Rockstar license

## Dependencies
- [qbx-core](https://github.com/Qbox-project/qbx-core)
- [qbx-spawn](https://github.com/Qbox-project/qbx-spawn) - Spawn selector
- [qbx-apartments](https://github.com/Qbox-project/qbx-apartments) - For giving the player a apartment after creating a character.
- [qbx-weathersync](https://github.com/Qbox-project/qbx-weathersync) - For adjusting the weather while player is creating a character.

## Screenshots
![Character Selection](https://cdn.izmystic.dev/images/n96bfssu.jpg)
![Character Registration](https://cdn.izmystic.dev/images/gs2nucbw.jpg)

## Features
- Ability to create up to 5 characters and delete any character.
- Ability to see character information during selection.

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Add the following code to your server.cfg/resouces.cfg
```
ensure qb-core
ensure qb-multicharacter
ensure qb-spawn
ensure qb-apartments
ensure qb-clothing
ensure qb-weathersync
```
