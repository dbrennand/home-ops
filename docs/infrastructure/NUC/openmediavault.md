# OpenMediaVault 6

!!! quote "What is OpenMediaVault?"

    [OpenMediaVault](https://www.openmediavault.org/) is the next generation network attached storage (NAS) solution based on Debian Linux. It contains services like SSH, (S)FTP, SMB/CIFS, RSync and many more ready to use.

This page contains instructions for configuring OpenMediaVault 6 on my NUC prior to running the [Ansible playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/archive/nuc/README.md).

## Networking

1. On the left menu, navigate to `Network > Interfaces` and edit the default interface:

    <!-- Create Markdown table with two columns named Setting and Value -->

    | Setting                            | Value          |
    | ---------------------------------- | -------------- |
    | IPv4 Method                        | Static         |
    | IPv4 Address                       | 192.168.0.3    |
    | IPv4 Netmask                       | 255.255.255.0  |
    | IPv4 Gateway                       | 192.168.0.1    |
    | Advanced settings - DNS servers    | 192.168.0.2    |
    | Advanced settings - Search domains | net.domain.tld |

2. Click **Save** and then **Apply changes**.

## Users

1. On the left menu, navigate to `Users > Users` and click **Create | Import**:

    | Setting                     | Value                     |
    | --------------------------- | ------------------------- |
    | Name                        | Enter username            |
    | Email                       | Enter email               |
    | Password - Confirm Password | Enter password            |
    | Shell                       | `/bin/bash`               |
    | Groups                      | `ssh`, `sudo`, `users`    |
    | SSH public keys             | Paste your SSH public key |

2. Click **Save** and then **Apply changes**.

## Storage

1. On the left menu, navigate to `Storage > Disks` and click **Scan for new devices**.

2. Under `Storage` select `File Systems` and click **Create | Mount**.

3. Under `Device` select your discovered disk and leave the type as `EXT4`.

4. Click **Save** and then **Apply changes**.

5. Under `Storage` select `Shared Folders` and click **Create**:

    - Create the following shared folders:

        | Name        | File System                              | Relative Path        | Permissions                                                     | Comment          |
        | ----------- | ---------------------------------------- | -------------------- | --------------------------------------------------------------- | ---------------- |
        | `appdata`   | Select file system on disk created above | `appdata/`           | Administrator: read/write, Users: read/write, Others: read-only | Application Data |
        | `data`      |                                          | `data/`              |                                                                 | Data             |
        | `downloads` |                                          | `data/downloads/`    |                                                                 | Downloads        |
        | `jellyfin`  |                                          | `appdata/jellyfin/`  |                                                                 | Jellyfin         |
        | `media`     |                                          | `data/media`         |                                                                 | Media            |
        | `movies`    |                                          | `data/media/movies/` |                                                                 | Movies           |
        | `prowlarr`  |                                          | `appdata/prowlarr/`  |                                                                 | Prowlarr         |
        | `radarr`    |                                          | `appdata/radarr/`    |                                                                 | Radarr           |
        | `sonarr`    |                                          | `appdata/sonarr/`    |                                                                 | Sonarr           |
        | `tv`        |                                          | `data/media/tv/`     |                                                                 | TV               |

        Tree structure:

        ```
        .
        ├── appdata
        │   ├── jellyfin
        │   ├── prowlarr
        │   ├── radarr
        │   ├── sonarr
        ├── data
        │   ├── downloads
        │   └── media
        │       ├── movies
        │       └── tv
        ```

6. Click **Save** and then **Apply changes** for each shared folder.

## SSH

1. On the left menu, navigate to `Services` and click **SSH**.

2. Disable `Permit root login` and `Password authentication`.

3. Enable `Public key authentication`.

4. Click **Save** and then **Apply changes**.
