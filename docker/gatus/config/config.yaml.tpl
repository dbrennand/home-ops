storage:
  type: sqlite
  path: /data/data.db

alerting:
  discord:
    webhook-url: {{ op://Apps/Gatus/DISCORD_WEBHOOK }}

endpoints:
  - name: danielbrennand.com
    group: personal
    url: "https://danielbrennand.com/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: pihole01.net.dbren.uk
    group: home-ops
    url: "https://pihole01.net.dbren.uk/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: pihole02.net.dbren.uk
    group: home-ops
    url: "http://pihole02.net.dbren.uk/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: proxmox01.net.dbren.uk
    group: home-ops
    url: "https://proxmox01.net.dbren.uk:8006/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: proxmox02.net.dbren.uk
    group: home-ops
    url: "https://proxmox02.net.dbren.uk:8006/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: backup01.net.dbren.uk
    group: home-ops
    url: "https://backup01.net.dbren.uk:8007/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: auth.net.dbren.uk
    group: home-ops
    url: "https://auth.net.dbren.uk/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: vikunja.net.dbren.uk
    group: home-ops
    url: "https://vikunja.net.dbren.uk/"
    interval: 2m
    conditions:
      - "[STATUS] == 200"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: minecraft01.net.dbren.uk
    group: minecraft
    url: "tcp://minecraft01.net.dbren.uk:25565"
    interval: 1m
    conditions:
      - "[CONNECTED] == true"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true

  - name: minecraft02.net.dbren.uk
    group: minecraft
    url: "tcp://minecraft02.net.dbren.uk:25565"
    interval: 1m
    conditions:
      - "[CONNECTED] == true"
    alerts:
      - type: discord
        description: "Healthcheck failed"
        send-on-resolved: true
