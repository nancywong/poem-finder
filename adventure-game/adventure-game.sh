#!/bin/sh

# game variables
game=""
name=""
room="0"
num_pieces="0"
poem=""

# game fxns
greet ()
{
    printf "hi there. what's your name?\n"
    read name

    printf "\nhi $name."
    printf "\nthis morning, i lost a haiku. will you help me find it? (yes)\n"
    read response

    printf "\nyay thanks.\ntake a where around. you can always type in 'help' for a list of commands\n"

    where
    help
}

help ()
{
    printf "\n     where"
    printf "\n     goto  <room-number>\n"
    printf "\n     open  <thing>"
    printf "\n     take  <object>"
    printf "\n     use   <object>\n"
    printf "\n     help"
    printf "\n     quit"
    printf "\n"
}

where ()
{
    cat room.txt
    printf "\n"
    printf "you have $num_pieces poem pieces. i think you need $((3 - $num_pieces)) more.\n\n"
}

get_poem_piece ()
{
    cat *.txt
    cat *.txt >> ../poem.txt
}

goto ()
{
    valid="4750"
    if [[ $valid == *"$1"* ]]; then
        printf "you leave room $room and walk into room %s\n\n" $1

        # set room
        room="`basename $(pwd)`"
        if [[ $room == "adventure-game" ]]; then
            room=0
        fi

        case $1 in
            0) if [[ $room != "0" ]]; then
                   cd .. 
               fi ;;
            *) cd $1 ;;
        esac
        where
    else
        invalid_move
    fi
}

open ()
{
    valid_obj="book envelope"
    if [[ $valid_obj == *"$1"* ]]; then
        printf "\nyou opened the $1. inside, there is a poem piece. you should take it.\n"
    else
        invalid_move
    fi
}

use ()
{
    valid_obj="piano"
    if [[ $valid_obj == *"$1"* ]]; then
        printf "\nyou play the $1. you didn't know you could, but somehow the music just came out!\n"
        printf "the top of the piano pops open. inside, there is a poem piece. you should take it.\n"
    else
        invalid_move
    fi
}

take ()
{
    valid_obj="poem piece"
    if [[ $valid_obj == *"$1"* ]]; then
        printf "\nyou took the poem piece. it reads:\n"
        cat line*.txt
        printf "\n"

        piece=$(cat line*.txt)
        num_pieces=$(($num_pieces + 1))
        poem="$poem $piece"

    else
        invalid_move
    fi
}

quit ()
{
    printf "\nbye!!!\n"
}

invalid_move ()
{
    printf "\ni'm sorry $name, i'm afraid i can't do that.\n"
}

game_over ()
{
    cat win.txt
}

##### GAME #####
greet

# game loop
while :
do
    if [[ $num_pieces != "3" ]]; then
        read user_input1 user_input2

        echo $user_input1 $user_input2
        case $user_input1 in
            where) where ;;
            goto) goto $user_input2 ;;
            open) open $user_input2 ;;
            use) use $user_input2 ;;
            take) take $user_input2 ;;
            help) help; cd ..; pwd ;;
            quit) quit; break ;;
            *) invalid_move
        esac
    else
        printf "\nyou did it. my poem is complete. thanks $name. i wonder what i should title it. what do you think is a word that captures this poem well?\n"
        read title
        printf "\n$title, perfect. here's the poem:\n"
        printf "%s\n" "$poem"
        printf "\nthanks for all of your help $name. have a great day.\n\n"
        break
    fi
done

