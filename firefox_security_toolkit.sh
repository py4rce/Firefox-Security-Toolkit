#!/bin/bash
################################################################################
## Firefox Security Toolkit
## Description:
# This script automatically transform Firefox Browser to a penetration testing suite.
# The script mainly focuses on downloading the required and useful add-ons for web-application penetration testing.
# You can decide where you want to install an addon or not directly on firefox
## Version:
# v0.1
## Homepage:
# https://github.com/py4rce/Firefox-Security-Toolkit
## Inspired by:
#  https://github.com/SpeksForks/Firefox-Security-Toolkit
################################################################################
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

logo() {
echo -e '    ______ _              ____                _____                           _  __            ______               __ __ __  _  __ '
echo '   / ____/(_)_____ ___   / __/____   _  __   / ___/ ___   _____ __  __ _____ (_)/ /_ __  __   /_  __/____   ____   / // //_/ (_)/ /_'
echo '  / /_   / // ___// _ \ / /_ / __ \ | |/_/   \__ \ / _ \ / ___// / / // ___// // __// / / /    / /  / __ \ / __ \ / // ,<   / // __/'
echo ' / __/  / // /   /  __// __// /_/ /_>  <    ___/ //  __// /__ / /_/ // /   / // /_ / /_/ /    / /  / /_/ // /_/ // // /| | / // /_  '
echo '/_/    /_//_/    \___//_/   \____//_/|_|   /____/ \___/ \___/ \__,_//_/   /_/ \__/ \__, /    /_/   \____/ \____//_//_/ |_|/_/ \__/  '
echo '                                                                                  /____/                                            '
echo "__________                _____ __________ _________  ___________ "
echo "\______   \ ___.__.      /  |  |\______   \\_   ___ \ \_   _____/ "
echo " |    |  _/<   |  |     /   |  |_|       _//    \  \/  |    __)_  "
echo " |    |   \ \___  |    /    ^   /|    |   \\     \____ |        \ "
echo " |______  / / ____|    \____   | |____|_  / \______  //_______  / "
echo "        \/  \/              |__|        \/         \/         \/  "
echo "v0.1"
echo "github.com/py4rce"
}

logo
welcome() {
echo -e "\n\n"
echo -e "Usage:\n\t"
echo -e "bash $0 run"
echo -e "\n"
echo -e '[%%] Available Add-ons:'
echo -e "${RED}* Copy PlainText
* Link Gopher
* Copy All Tab URL
* SNAP Links
* Open multiple Links
* CSRF Spotter
* Easy XSS
* FlagFox
* FoxyProxy
* Google Dork Builder
* Hackbar V2
* Hackbar Quantum
* WEB RTC
* HTTP Header Live
* JSON View
* KNOXSS Community Edition
* Redurrect Pages
* Shodan.io
* User-Agent Switcher and manager
* Wappalyzer
* WebDeveloper
* XML ViewerPlus
* HackTools
* PostMessageTracker ${NC}
"

echo '[%%] Additions & Features:'
echo -e "* Downloading ${ORANGE}Burp Suite certificate ${NC}"
echo -e "* Downloading a ${RED}large user-agent list for User-Agent Switcher ${NC}"
echo -e "\n\n"
echo "[$] Legal Disclaimer: Usage of Firefox Security Toolkit for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program"
}

if [[ $1 != 'run' ]];then
  welcome
  exit 0
else
  echo -en "\n\n[#] Click [Enter] to start. "; read -r
fi

if [[ -z $FIREFOXPATH ]]; then
  if [[ ! -z $(which firefox) ]]; then
    FIREFOXPATH=$(which firefox)
  elif [[ "$(uname)" == "Darwin" ]];then
    FIREFOXPATH="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
  else
    FIREFOXPATH='/usr/bin/firefox'
  fi
fi


# checking whether Firefox is installed.
if [[ ! -f "$FIREFOXPATH" ]]; then
  echo -e "[*] Firefox does not seem to be installed.\n[*]Quitting..."
  exit 1
fi

echo -e "${RED}[*] Firefox path: $FIREFOXPATH ${NC}"

# creating a tmp directory.
scriptpath=$(mktemp -d)
echo -e "${RED}[*] Created a tmp directory at [$scriptpath].${NC}"

# inserting a "Installation is Finished" page into $scriptpath.
echo '<!DOCTYPE HTML><html><center><head><h1>Installation is Finished</h1></head><body><p><h2>You can close Firefox.</h2><h3><i>Firefox Security Toolkit</i></h3></p></body></center></html>' > "$scriptpath/.installation_finished.html"

# checks whether the user would like to download Burp Suite certificate.
echo -e "${ORANGE}[@] Would you like to download Burp Suite certificate? [y/n]. (Note: Burp Suite should be running in your machine): ${NC}"; read -r burp_cert_answer
  burp_cert_answer=$(echo -n "$burp_cert_answer" | tr '[:upper:]' '[:lower:]')
  if [[ ( $burp_cert_answer == 'y' ) || ( $burp_cert_answer == 'yes' ) ]];then
    echo -n "[@] Enter Burp Suite proxy listener's port (Default: 8080): "; read -r burp_port
    if [[ $burp_port == '' ]]; then
      burp_port='8080'
    fi
    wget "http://127.0.0.1:$burp_port/cert" -o /dev/null -O "$scriptpath/cacert.der"
    if [ -s "$scriptpath/cacert.der" ];then
      echo -e "[*] Burp Suite certificate has been downloaded, and can be found at [$scriptpath/cacert.der]."
    else
      echo "[!]Error: Firefox Security Toolkit was not able to download Burp Suite certificate, you need to do this task manually."
    fi
  fi

# downloading packages.
echo -e "[*] Downloading Add-ons."

#Web Developer : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4306323/web_developer-3.0.1.xpi" -o /dev/null -O "$scriptpath/web_developer-3.0.1.xpi"


# Link Gopher : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4183832/link_gopher-2.6.2.xpi" -o /dev/null -O "$scriptpath/link_gopher-2.6.2.xpi"

#  Copy All Tab URL : OK
wget "https://addons.mozilla.org/firefox/downloads/file/3988710/copy_all_tab_urls_we-2.2.0.xpi" -o /dev/null -O "$scriptpath/copy_all_tab_urls_we-2.2.0.xpi"
#  SNAP Links : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4393740/snaplinksplus-3.1.15.xpi" -o /dev/null -O "$scriptpath/snaplinksplus-3.1.15.xpi"
#  Open multiple Links : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4444103/open_multiple_urls-1.7.4.xpi" -o /dev/null -O "$scriptpath/open_multiple_urls-1.7.4.xpi"

# Copy PlainText : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4143512/copy_plaintext-1.15.xpi" -o /dev/null -O "$scriptpath/copy_plaintext-1.xpi"

# CSRF spotter : OK
wget "https://addons.mozilla.org/firefox/downloads/file/2209785/csrf_spotter-1.0.xpi" -o /dev/null -O "$scriptpath/csrf_spotter-1.0.xpi"

# Easy XSS : OK
wget "https://addons.mozilla.org/firefox/downloads/file/1158849/easy_xss-1.0-fx.xpi" -o /dev/null -O "$scriptpath/easy_xss-1.0-fx.xpi"

# Flagfox: OK
wget "https://addons.mozilla.org/firefox/downloads/file/4428652/flagfox-6.1.83.xpi" -o /dev/null -O "$scriptpath/flagfox-6.1.83.xpi"

# FoxyProxy Standard: OK
wget "https://addons.mozilla.org/firefox/downloads/file/4425860/foxyproxy_standard-8.10.xpi" -o /dev/null -O "$scriptpath/foxyproxy_standard-8.10.xpi"

# Google Dork Builder : OK
wget "https://addons.mozilla.org/firefox/downloads/file/3864393/google_dork_builder-0.9.xpi" -o /dev/null -O "$scriptpath/google_dork_builder-0.9.xpi"

# HackBar V2 : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4399104/hackbar_free-2.5.4.xpi" -o /dev/null -O "$scriptpath//hackbar_free-2.5.4.xpi"

# HackBar Quantum: OK
wget "https://addons.mozilla.org/firefox/downloads/file/4274533/quantum_hackbar-1.0.2resigned1.xpi" -o /dev/null -O "$scriptpath/quantum_hackbar-1.0.2resigned1.xpi"

# Disable WebRTC : OK
wget "https://addons.mozilla.org/firefox/downloads/file/3551985/happy_bonobo_disable_webrtc-1.0.23.xpi" -o /dev/null -O "$scriptpath/happy_bonobo_disable_webrtc-1.0.23.xpi"

# HTTP Header Live:OK
wget "https://addons.mozilla.org/firefox/downloads/file/3384326/http_header_live-0.6.5.2.xpi" -o /dev/null -O "$scriptpath/http_header_live-0.6.5.2.xpi"

# JSONView : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4419512/jsonview-3.1.0.xpi" -o /dev/null -O "$scriptpath/jsonview-3.1.0.xpi"

# KNOXSS Community Edition : OK
wget "https://addons.mozilla.org/firefox/downloads/file/3378216/knoxss_community_edition-0.2.0.xpi" -o /dev/null -O "$scriptpath/knoxss_community_edition-0.2.0.xpi"

# Resurrect Pages: OK
wget "https://addons.mozilla.org/firefox/downloads/file/3640440/resurrect_pages-8.xpi" -o /dev/null -O "$scriptpath/resurrect_pages-8.xpi"

# Shodan.io: OK
wget "https://addons.mozilla.org/firefox/downloads/file/4117305/shodan_addon-1.1.1.xpi" -o /dev/null -O "$scriptpath/shodan_addon-1.1.1.xpi"

# User-Agent Switcher and Manager: OK
wget "https://addons.mozilla.org/firefox/downloads/file/4098688/user_agent_string_switcher-0.5.0.xpi" -o /dev/null -O "$scriptpath/user_agent_string_switcher-0.5.0.xpi"

# Wappalyzer : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4431384/wappalyzer-6.10.79.xpi" -o /dev/null -O "$scriptpath/wappalyzer-6.10.79.xpi"

# Web Developer : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4306323/web_developer-3.0.1.xpi" -o /dev/null -O "$scriptpath/web_developer-3.0.1.xpi"

# XML Viewer Plus : OK
wget "https://addons.mozilla.org/firefox/downloads/file/3032172/xml_viewer-1.2.6.xpi" -o /dev/null -O "$scriptpath/xml_viewer-1.2.6.xpi"

# HackTools : OK
wget "https://addons.mozilla.org/firefox/downloads/file/3901885/hacktools-0.4.0.xpi" -o /dev/null -O "$scriptpath/hacktools-0.3.2-fx.xpi"

# Post message Tracker : OK
wget "https://addons.mozilla.org/firefox/downloads/file/4226437/postmessage_tracker_f-1.1.2.xpi" -o /dev/null -O "$scriptpath/postmessage_tracker_f-1.1.2.xpi"

echo -n "[@] Would you like to download my daily extensions that I personally use? [y/n]: "; read -r daily_use_answer
 
  if [[ ( $daily_use_answer == 'y' )  ]; then
    wget 'https://addons.mozilla.org/firefox/downloads/file/4439735/darkreader-4.9.103.xpi' -o /dev/null -O "$scriptpath/darkreader-4.9.103.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/3449086/df_youtube-1.13.504.xpi' -o /dev/null -O "$scriptpath/df_youtube-1.13.504.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/4355970/multi_account_containers-8.2.0.xpi' -o /dev/null -O "$scriptpath/multi_account_containers-8.2.0.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/4465106/jump_cutter-1.30.0.xpi' -o /dev/null -O "$scriptpath/jump_cutter-1.30.0.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/4455681/traduzir_paginas_web-10.1.1.1.xpi' -o /dev/null -O "$scriptpath/traduzir_paginas_web-10.1.1.1.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/4458679/vimium_ff-2.2.1.xpi' -o /dev/null -O "$scriptpath/vimium_ff-2.2.1.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/4467365/doqment-1.0.1.xpi' -o /dev/null -O "$scriptpath/doqment-1.0.1.xpi"
    wget 'https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi' -o /dev/null -O "$scriptpath/tabliss-2.6.0.xpi"
 
    
    echo -e "[*]Additional extensions has been installed."
  fi


# checks whether to download user-agent list for User-Agent Switcher add-on.
#echo -n "[@] Would you like to download user-agent list for User-Agent Switcher add-on? [y/n]: "; read -r useragent_list_answer
#  useragent_list_answer=$(echo -n "$useragent_list_answer" | tr '[:upper:]' '[:lower:]')
#  if [[ ( $useragent_list_answer == 'y' ) || ( $useragent_list_answer == 'yes' ) ]]; then
#    wget 'https://techpatterns.com/downloads/firefox/useragentswitcher.xml' -o /dev/null -O "$scriptpath/useragentswitcher.xml"
#    echo -e "[*]Additional user-agents has been downloaded for \"User-Agent Switcher\" add-on, you can import it manually. It can be found at: [$scriptpath/useragentswitcher.xml]."
#  fi

# messages.
echo -e "[*] Downloading add-ons completed.\n";
echo -en "[@@] Click [Enter] to run Firefox to perform the task. (Note: Firefox will be restarted) "; read -r
echo -e "[*] Running Firefox to install the add-ons.\n"
echo -e "Click confirm on the prompt, and close Firefox, until all addons are installed"
# installing the add-ons.
# the process needs to be semi-manually due to Mozilla Firefox security policies.

# stopping Firefox if it's running.
killall firefox &> /dev/null
# installing
# "$FIREFOXPATH" "$scriptpath/"*.xpi "$scriptpath/.installation_finished.html" &> /dev/null
for extension in $(find $scriptpath -type f -name "*.xpi"); do
  echo "- $extension"
  "$FIREFOXPATH" --new-tab "$extension"
done
"FIREFOXPATH" "$scriptpath/.installation_finished.html"

####

# in case you need to delete the tmp directory, uncomment the following line.
#rm -rf "$scriptpath"; echo -e "[*]Deleted the tmp directory."
echo -e "[**] Firefox Security Toolkit is finished\n"
echo -e "Have a nice day! "

# END #
