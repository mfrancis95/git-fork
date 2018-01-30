show_usage() {
    echo 'Usage: git-fork owner repo'
    exit $1
}

if [ $# -eq 0 ]; then
    show_usage 1
elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_usage 0
elif [ $# -lt 2 ]; then
    show_usage 1
else
    read -p 'Enter username: ' username
    output=$(mktemp)
    response=$(curl -o $output -s -u $username -w '%{http_code}' -X POST https://api.github.com/repos/$1/$2/forks)
    if [ "$response" == "202" ]; then
        git clone https://github.com/$username/$2
    else
        cat $output
    fi
    rm $output
fi
