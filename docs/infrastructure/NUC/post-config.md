# NUC Ansible Playbook - Application Configuration

This page contains instructions for configuring the applications deployed by the [Ansible playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/nuc/README.md).

## Sonarr & Radarr

1. Go to `Settings > Media Management` and click **Show Advanced**.

2. Configure the following settings:

    !!! tip

        Shoutout to TRaSH Guides for the naming formats and other settings:

        * [Radarr](https://trash-guides.info/Radarr/Radarr-recommended-naming-scheme/)

        * [Sonarr](https://trash-guides.info/Sonarr/Sonarr-recommended-naming-scheme/)

    | Setting                         | Value                                                                                                                                                                                                                                                                                                             |
    | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | Rename Episodes / Rename Movies | ✅                                                                                                                                                                                                                                                                                                                 |
    | Replace Illegal Characters      | ✅                                                                                                                                                                                                                                                                                                                 |
    | Standard Movie Format           | `{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels}][{Mediainfo VideoCodec}]{-Release Group}`                                                          |
    | Movie Folder Format             | `{Movie CleanTitle} ({Release Year}) [imdbid-{ImdbId}]`                                                                                                                                                                                                                                                           |
    | Standard Episode Format         | `{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Preferred Words }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`                                                                           |
    | Daily Episode Format            | `{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Preferred Words }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}`                                                                                          |
    | Anime Episode Format            | `{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Preferred Words }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}` |
    | Series Folder Format            | `{Series TitleYear} [tvdbid-{TvdbId}]`                                                                                                                                                                                                                                                                            |
    | Season Folder Format            | `Season {season:00}`                                                                                                                                                                                                                                                                                              |
    | Multi-Episode Style             | Prefixed Range                                                                                                                                                                                                                                                                                                    |
    | Delete empty folders            | ✅                                                                                                                                                                                                                                                                                                                 |
    | Use Hardlinks instead of Copy   | ✅                                                                                                                                                                                                                                                                                                                 |
    | Propers and Repacks             | Do not Prefer                                                                                                                                                                                                                                                                                                     |

3. Click **Add Root Folder** and configure the path to:

    Sonarr: `/data/media/tv`

    Radarr: `/data/media/movies`

4. Go to `Settings > Quality` and set the quality definitions from TRaSH guides:

    - [Radarr](https://trash-guides.info/Radarr/Radarr-Quality-Settings-File-Size/#radarr-quality-definitions)
    - [Sonarr](https://trash-guides.info/Sonarr/Sonarr-Quality-Settings-File-Size/#sonarr-quality-definitions)

5. Go to `Settings > Download Clients` and click the `+` button.

6. Under *Torrents* select **Transmission** and enter the following settings:

    | Setting          | Value          |
    | ---------------- | -------------- |
    | Name             | `Transmission` |
    | Enable           | ✅              |
    | Host             | `transmission` |
    | Port             | `9091`         |
    | Remove Completed | ✅              |

7. Click **Save**.

8. Go to `Settings > General` and under *Analytics* disable the checkbox.

## Prowlarr

1. Go to `Settings > Indexers` and click **Show Advanced**.

2. Click the `+` button to add an indexer proxy.

3. Select `Http` and enter the following settings:

    | Setting | Value          |
    | ------- | -------------- |
    | Name    | `Privoxy`      |
    | Tags    | `privoxy`      |
    | Host    | `transmission` |
    | Port    | `8118`         |

4. Click **Save**.

5. Go to `Settings > Apps` and click the `+` button to add an application.

6. Add two applications for Sonarr and Radarr respectively:

    | Setting         | Value                                    |
    | --------------- | ---------------------------------------- |
    | Name            | `Sonarr`                                 |
    | Sync Level      | `Full Sync`                              |
    | Prowlarr Server | `https://prowlarr.net.domain.tld`        |
    | Sonarr Server   | `http://sonarr:8989`                     |
    | ApiKey          | `Sonarr API key from Settings > General` |

    | Setting         | Value                                    |
    | --------------- | ---------------------------------------- |
    | Name            | `Radarr`                                 |
    | Sync Level      | `Full Sync`                              |
    | Prowlarr Server | `https://prowlarr.net.domain.tld`        |
    | Sonarr Server   | `http://radarr:7878`                     |
    | ApiKey          | `Radarr API key from Settings > General` |

7. Click **Save**.

8. Go to `Settings > Notifications` and click the `+` button to add a connection.

9. Select `Telegram` and enter the following settings:

    | Setting               | Value                                                  |
    | --------------------- | ------------------------------------------------------ |
    | Name                  | `Telegram`                                             |
    | Notification Triggers | `On Health Issue`, `On Application Update`             |
    | Bot Token             | `Enter Telegram bot token from https://t.me/BotFather` |
    | Chat ID               | `Enter Telegram chat ID from https://t.me/userinfobot` |

10. Click **Save**.

11. Go to `Indexers` and click **Add Indexer**.

12. Select an indexer from the list and when configuring, make sure to add the `privoxy` tag so traffic is routed through the proxy.

## Jellyfin

1. Login to Jellyfin and under *Administration* go to `Dashboard > Libraries`.

2. Click **Add Media Library** and add one for movies and shows respectively:

    Movies: `/data/media/movies`

    Shows: `/data/media/tv`

3. Under `Playback` select `Intel QuickSync (QSV)` as the hardware acceleration option.

4. Check **Throttle Transcodes** and click **Save**.

5. Under `Networking` check `Allow remote connections to this server` and click **Save**.

Enjoy! ✨🚀
