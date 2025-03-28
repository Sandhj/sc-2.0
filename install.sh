#!/bin/bash

# < Export Data Variable >
export IP=$( curl -sS ipinfo.io/ip )
REPO="https://raw.githubusercontent.com/Paper890/san/main/"
    
#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════
function input_domain(){
mkdir -p /etc/xray
touch /etc/xray/domain
clear
echo -e "---------------------------------------------------"
echo -e "     _______   _  __  ______________  ___  ____    "
echo -e "    / __/ _ | / |/ / / __/_  __/ __ \/ _ \/ __/    "
echo -e "   _\ \/ __ |/    / _\ \  / / / /_/ / , _/ _/      "
echo -e "  /___/_/ |_/_/|_/ /___/ /_/  \____/_/|_/___/      "
echo -e "                                                   "
echo -e "          BUY PERMISION : 085155208019             "
echo -e "---------------------------------------------------"
echo ""
echo -e "————————————————————————————————————————"
echo -e "     Domain Manager For this Script       "
echo -e "————————————————————————————————————————"
read -p "Input domain kamu : " host1    
clear
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════
function instal_system(){
apt install -y wget screen
apt update -y && apt upgrade -y
apt install lolcat -y
gem install lolcat
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════
function is_root() {
    if [[ 0 == "$UID" ]]; then
        print_ok "Root user Start installation process"
    else
        print_error "The current user is not the root user, please switch to the root user and run the script again"
    fi

}
#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function buat_direktori(){
    mkdir -p /etc/xray
    curl -s ipinfo.io/city >> /etc/xray/city
    curl -s ifconfig.me > /etc/xray/ipvps
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp
    touch /etc/xray/domain
    mkdir -p /var/log/xray
    chown www-data.www-data /var/log/xray
    chmod +x /var/log/xray
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════
function setup_env(){
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    
    sudo apt update -y
    apt-get install --no-install-recommends software-properties-common
    add-apt-repository ppa:vbernat/haproxy-2.0 -y
    apt-get -y install haproxy=2.0.\*

    sudo apt-get install nginx -y 
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════
function base_package() {
    apt install zip pwgen openssl netcat socat cron bash-completion -y
    apt install figlet -y
    apt dist-upgrade -y
    apt-get install chrony -y
    systemctl enable chronyd
    systemctl restart chronyd
    systemctl enable chrony
    systemctl restart chrony
    chronyc sourcestats -v
    chronyc tracking -v
    apt install ntpdate -y
    ntpdate pool.ntp.org
    apt install sudo -y
    sudo apt-get clean all
    sudo apt-get autoremove -y
    sudo apt-get install -y debconf-utils
    sudo apt-get remove --purge exim4 -y
    sudo apt-get remove --purge ufw firewalld -y
    sudo apt-get install -y --no-install-recommends software-properties-common
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    sudo apt-get install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential gcc g++ python htop lsof tar wget curl ruby zip unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates bsd-mailx iptables iptables-persistent netfilter-persistent net-tools openssl ca-certificates gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa
    
}
#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function pasang_domain() {
echo $host1 > /etc/xray/domain
echo $host1 > /root/domain
}
#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function pasang_ssl() {
    rm -rf /etc/xray/xray.key
    rm -rf /etc/xray/xray.crt
    domain=$(cat /root/domain)
    STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
    rm -rf /root/.acme.sh
    mkdir /root/.acme.sh
    systemctl stop $STOPWEBSERVER
    systemctl stop nginx
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    chmod 777 /etc/xray/xray.key
    
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function make_folder_xray() {
    mkdir -p /etc/bot
    mkdir -p /etc/xray
    mkdir -p /etc/vmess
    mkdir -p /etc/vless
    mkdir -p /etc/trojan
    mkdir -p /etc/shadowsocks
    mkdir -p /etc/ssh
    mkdir -p /usr/bin/xray/
    mkdir -p /var/log/xray/
    mkdir -p /var/www/html
    chmod +x /var/log/xray
    touch /etc/xray/domain
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log 
    }

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function install_xray() {
    # install xray
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
    chown www-data.www-data $domainSock_dir
    
    # / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
 
    # // Ambil Config Server
    wget -O /etc/xray/config.json "${REPO}xray/config.json" >/dev/null 2>&1
    #wget -O /usr/local/bin/xray "${REPO}xray/xray.linux.64bit" >/dev/null 2>&1
    wget -O /etc/systemd/system/runn.service "${REPO}xray/runn.service" >/dev/null 2>&1
    #chmod +x /usr/local/bin/xray
    domain=$(cat /etc/xray/domain)
    IPVS=$(cat /etc/xray/ipvps)
    print_success "Core Xray 1.8.1 Latest Version"
    
    # Settings UP Nginix Server
    clear
    curl -s ipinfo.io/city >>/etc/xray/city
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >>/etc/xray/isp
    print_install "Memasang Konfigurasi Packet"
    wget -O /etc/haproxy/haproxy.cfg "${REPO}xray/haproxy.cfg" >/dev/null 2>&1
    wget -O /etc/nginx/conf.d/xray.conf "${REPO}xray/xray.conf" >/dev/null 2>&1
    sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
    curl ${REPO}ssh/nginx.conf > /etc/nginx/nginx.conf
    
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem

    # > Set Permission
    chmod +x /etc/systemd/system/runn.service

    # > Create Service
    rm -rf /etc/systemd/system/xray.service.d
    cat >/etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
}

══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ssh(){
    wget -O /etc/pam.d/common-password "${REPO}ssh/password"
chmod +x /etc/pam.d/common-password

    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/compose select No compose key"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layoutcode string de"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/modelcode string pc105"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/optionscode string "
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/switch select No temporary switch"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/toggle select No toggling"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_options boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_layout boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_options boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variantcode string "
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/xkb-keymap select "

cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function instal_udp(){
mkdir -p /usr/local/badvpn/
wget -q -O /usr/local/badvpn/udp-mini "${REPO}badvpn/udp-mini"
chmod +x /usr/local/badvpn/udp-mini
wget -q -O /etc/systemd/system/udp-mini-1.service "${REPO}badvpn/udp-mini-1.service"
wget -q -O /etc/systemd/system/udp-mini-2.service "${REPO}badvpn/udp-mini-2.service"
wget -q -O /etc/systemd/system/udp-mini-3.service "${REPO}badvpn/udp-mini-3.service"
systemctl disable udp-mini-1
systemctl stop udp-mini-1
systemctl enable udp-mini-1
systemctl start udp-mini-1
systemctl disable udp-mini-2
systemctl stop udp-mini-2
systemctl enable udp-mini-2
systemctl start udp-mini-2
systemctl disable udp-mini-3
systemctl stop udp-mini-3
systemctl enable udp-mini-3
systemctl start udp-mini-3
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

clear
function ins_SSHD(){
wget -q -O /etc/ssh/sshd_config "${REPO}ws/sshd" >/dev/null 2>&1
chmod 700 /etc/ssh/sshd_config
/etc/init.d/ssh restart
systemctl restart ssh
/etc/init.d/ssh status
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

clear
function ins_dropbear(){
apt-get install dropbear -y > /dev/null 2>&1
wget -q -O /etc/default/dropbear "${REPO}ssh/dropbear.conf"
chmod +x /etc/default/dropbear
/etc/init.d/dropbear restart
/etc/init.d/dropbear status
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ins_vnstat(){
apt -y install vnstat > /dev/null 2>&1
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev > /dev/null 2>&1
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ins_openvpn(){
wget ${REPO}ssh/openvpn &&  chmod +x openvpn && ./openvpn
/etc/init.d/openvpn restart
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ins_swab(){
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1
    
        # > Buat swap sebesar 1G
    dd if=/dev/zero of=/swapfile bs=1024 count=1048576
    mkswap /swapfile
    chown root:root /swapfile
    chmod 0600 /swapfile >/dev/null 2>&1
    swapon /swapfile >/dev/null 2>&1
    sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

    # > Singkronisasi jam
    chronyd -q 'server 0.id.pool.ntp.org iburst'
    chronyc sourcestats -v
    chronyc tracking -v
    
    wget ${REPO}bbr.sh &&  chmod +x bbr.sh && ./bbr.sh
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ins_Fail2ban(){
apt -y install fail2ban > /dev/null 2>&1
#sudo systemctl enable --now fail2ban
/etc/init.d/fail2ban restart
/etc/init.d/fail2ban status

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi

clear
# banner
echo "Banner /etc/kyt.txt" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/kyt.txt"@g' /etc/default/dropbear

# Ganti Banner
wget -O /etc/kyt.txt "${REPO}ssh/issue.net"
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ins_epro(){
    wget -O /usr/bin/ws "${REPO}ws/ws" >/dev/null 2>&1
    wget -O /usr/bin/tun.conf "${REPO}ws/tun.conf" >/dev/null 2>&1
    wget -O /etc/systemd/system/ws.service "${REPO}ws/ws.service" >/dev/null 2>&1
    chmod +x /etc/systemd/system/ws.service
    chmod +x /usr/bin/ws
    chmod 644 /usr/bin/tun.conf
systemctl disable ws
systemctl stop ws
systemctl enable ws
systemctl start ws
systemctl restart ws
wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" >/dev/null 2>&1
wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" >/dev/null 2>&1
wget -O /usr/sbin/ftvpn "${REPO}ws/ftvpn" >/dev/null 2>&1
chmod +x /usr/sbin/ftvpn
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# remove unnecessary files
cd
apt autoclean -y >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function ins_restart(){
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/vnstat restart
systemctl restart haproxy
/etc/init.d/cron restart
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now nginx
    systemctl enable --now xray
    systemctl enable --now rc-local
    systemctl enable --now dropbear
    systemctl enable --now openvpn
    systemctl enable --now cron
    systemctl enable --now haproxy
    systemctl enable --now netfilter-persistent
    systemctl enable --now ws
    systemctl enable --now fail2ban
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/openvpn
rm -f /root/key.pem
rm -f /root/cert.pem
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

#Instal Menu
function menu(){
    wget ${REPO}menu/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

# Membaut Default Menu 
function profile(){
clear
    cat >/root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
mesg n || true
menu
EOF
}

function service_menu() {
    # Menambahkan cron job untuk xp_all
    cat >/etc/cron.d/xp_all <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
EOF
    chmod 644 /etc/cron.d/xp_all || { echo "Gagal mengatur izin untuk xp_all cron job"; exit 1; }

    # Menambahkan cron job untuk daily reboot
    cat >/etc/cron.d/daily_reboot <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
EOF
    chmod 644 /etc/cron.d/daily_reboot || { echo "Gagal mengatur izin untuk daily_reboot cron job"; exit 1; }

    # Menambahkan cron job untuk membersihkan log nginx dan xray
    echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
    echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray

    # Memastikan layanan cron dijalankan ulang
    service cron restart || { echo "Gagal menjalankan ulang layanan cron"; exit 1; }

    # Menyimpan waktu reboot harian ke file /home/daily_reboot
    cat >/home/daily_reboot <<EOF
5
EOF
    chmod 644 /home/daily_reboot || { echo "Gagal mengatur izin untuk /home/daily_reboot"; exit 1; }

    # Membuat unit systemd untuk rc-local.service
    cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

    # Mengaktifkan dan menjalankan rc-local.service
    systemctl enable rc-local || { echo "Gagal mengaktifkan rc-local.service"; exit 1; }
    systemctl start rc-local || { echo "Gagal memulai rc-local.service"; exit 1; }

    # Menambahkan shell non-login ke /etc/shells
    echo "/bin/false" >>/etc/shells
    echo "/usr/sbin/nologin" >>/etc/shells

    # Menambahkan script rc.local
    cat >/etc/rc.local <<EOF
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

    # Memberikan izin eksekusi untuk rc.local
    chmod +x /etc/rc.local || { echo "Gagal memberikan izin eksekusi untuk /etc/rc.local"; exit 1; }

    # Mengecek waktu reboot otomatis
    AUTOREB=$(cat /home/daily_reboot)
    SETT=11
    if [ "$AUTOREB" -gt "$SETT" ]; then
        TIME_DATE="PM"
    else
        TIME_DATE="AM"
    fi
    echo "Waktu reboot otomatis: $AUTOREB:00 $TIME_DATE"
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function enable_services(){
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now rc-local
    systemctl enable --now cron
    systemctl enable --now netfilter-persistent
    systemctl restart nginx
    systemctl restart xray
    systemctl restart cron
    systemctl restart haproxy
}

#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════

function instal(){
input_domain
instal_system
is_root
buat_direktori
setup_env
base_package
pasang_domain
pasang_ssl
make_folder_xray
install_xray
ssh
instal_udp
ins_SSHD
ins_dropbear
ins_vnstat
ins_openvpn
ins_swab
ins_Fail2ban
ins_epro
ins_restart
menu
profile
service_menu
enable_services
}

instal
#══════════════════════════════⊹⊱≼≽⊰⊹══════════════════════════════
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain

echo -e "Successfully Install This Script"
