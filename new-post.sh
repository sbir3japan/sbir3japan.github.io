#!/bin/bash

title () {
    echo ""
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo "Insert the title of your article (you can always change it later, but remember to change the name of the file too):"
    echo "-------------------------------------------------------------------------------------------------------------------"
    read input3
    hugo new -k docs "$1/$input3.md"
}

echo "--------------------------------------------"
echo "Please, select the category of your article:"
echo "--------------------------------------------"
select d in $(find content/ja/docs/ -maxdepth 1 ! -path content/ja/docs/images ! -path content/ja/docs/ -type d)
do  
    ls $d/*/ >/dev/null 2>&1;
    if [ $? == 0 ]
    then
        echo ""
        echo "------------------------------------------------"
        echo "Please, select the sub-category of your article:"
        echo "------------------------------------------------"
        select e in $(find $d -maxdepth 1 ! -path $d -type d)
        do
            title $e; exit;
        done
    fi
    
    title $d; exit;
done