#!/bin/bash

getMonth(){
    filename=$1
    creation_time=$(stat -c "%w" $filename)
    month=$(date -d "$creation_time" +%B)
    echo "$month"
}

printFiles(){
    option=$1
    files=$2
    OPTARG=$3
    echo "Looking for files where the $option is: $OPTARG"
    for file in "${files[@]}"; do
             if [[ $option == "owner" ]]; then
                criteria=$(stat -c '%U' "$file")
             else
                criteria=$(getMonth "$file")
             fi
             lines=$(wc -l $file)
             if [[ $criteria == $OPTARG ]]; then
                echo "File: $file, Lines: $lines"            
             fi
    done
}



files=($(ls))

while getopts ":o:m:" opt; do
    case $opt in
       o)
        if [[ $OPTARG == "owner" ]]; then
            echo "invalid argument"
            exit 1
        fi
         printFiles "owner" $files $OPTARG 
        ;;
        
        m)
        if [[ $OPTARG == "month" ]]; then
            echo "invalid argument"
            exit 1
        fi

          printFiles "month" $files $OPTARG 
         ;;
        \?)
        echo "Invalid command"
        ;;
      esac
done

if [[ ! -z $owner && ! -z $month ]]; then
    echo "Uso incorrecto de argumentos"
    exit 1
fi


if [ $OPTIND -eq 1 ]; then
    echo "Se requieren argumentos"
    exit 1
fi
