#!/bin/bash

title () {
    echo ""
    echo "Please, select the title of the article (if you want to change it later, you will have to change the name of the file under $1/$2"
    read input3
    hugo new "docs/$1/$2/$input3.md"
}

dev_categories () {
    echo ""
    echo "Please, select the sub-category:"
    categories2=("cordapp_development" "design" "getting_started" "network_operations", "node_operations", "performance", "samples")
    select cat2 in "${categories2[@]}"; do
        echo "You chose $1/$cat2"
        title $1 $cat2
    done
}

echo "Please, select the category of your article:"
categories1=("developers" "FAQ" "release_note" "understanding_corda")
select cat1 in "${categories1[@]}"; do
    echo "You chose $cat1"
    dev_categories $cat1
    # case $cat1 in
    #     "developers")
            
    #         ;;
    #     "FAQ")
    #          echo "You chose $cat1"
	#     # optionally call a function or run some code here
    #         ;;
	# "Quit")
	#     echo "User requested exit"
	#     exit
	#     ;;
    #     *) echo "invalid option $REPLY";;
    # esac
done