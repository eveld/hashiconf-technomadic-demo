job "minecraft" {
    datacenters = ["dc1"]

    group "minecraft" {
        count = 1

        network {
            mode = "host"

            port "minecraft" {
                to = 25565
                static = 25565
            }

            port "rcon" {
                to = 25575
                static = 25575
            }
        }
        
        task "server" {
            driver = "java"

            template {
                destination = "/eula.txt"
                data = <<EOF
eula=true
EOF
            }

            template {
                perms = "666"
                destination = "/server.properties"
                data = <<EOF
broadcast-rcon-to-ops=true
view-distance=10
enable-jmx-monitoring=false
server-ip=
resource-pack-prompt=
rcon.port=25575
gamemode=creative
server-port=25565
allow-nether=true
enable-command-block=false
enable-rcon=true
sync-chunk-writes=true
enable-query=false
op-permission-level=4
prevent-proxy-connections=false
resource-pack=
entity-broadcast-range-percentage=100
level-name=world
rcon.password=hashicraft
player-idle-timeout=0
motd=HashiCraft
query.port=25565
force-gamemode=false
rate-limit=0
hardcore=false
white-list=false
broadcast-console-to-ops=true
pvp=true
spawn-npcs=true
spawn-animals=true
snooper-enabled=true
difficulty=easy
function-permission-level=2
network-compression-threshold=256
text-filtering-config=
require-resource-pack=false
spawn-monsters=false
max-tick-time=60000
enforce-whitelist=false
use-native-transport=true
max-players=20
resource-pack-sha1=
spawn-protection=0
online-mode=false
enable-status=true
allow-flight=false
max-world-size=29999984
EOF
            }

            template {
                perms = "666"
                destination = "/whitelist.json"
                data = <<EOF
[{
    name: "fstechnics",
    uuid: "783df1a4-039e-4a16-9f1f-adb0d1de44ef"
}]
EOF
            }

            template {
                perms = "666"
                destination = "/ops.json"
                data = <<EOF
[{
    name: "fstechnics",
    uuid: "783df1a4-039e-4a16-9f1f-adb0d1de44ef"
}]
EOF
            }

            artifact {
                source = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/server.zip"
                destination = "/"
            }

            artifact {
                source = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/mods.zip"
                destination = "/mods"
            }

            config {
                jar_path = "/fabric-server-launch.jar"
                args = ["nogui"]
                jvm_options = ["-Xmx2048m", "-Xms256m"]
            }

            resources {
                cpu = 100
                memory = 4096
            }
        }
    }
}
