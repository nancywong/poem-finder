#!/bin/sh

# game variables
game=""
name=""
room="0"

# game fxns
greet ()
{
    printf "hi there. what's your name?\n"
    read name

    printf "\nhi $name."
    printf "\nthis morning, i lost a haiku. will you help me find it? (y/n)\n"
    read yn

    case $yn in
        y) printf "\nyay thanks.\ntake a where around. you can always type in 'help' for a list of commands\n\n" ;;
        n) printf ":^( okay"; game="over" ;;
    esac

    help
}

help ()
{
    printf "%s6\n" "where"
    printf "%s6\n" "goto" "<room>\n"
    printf "%s6\n" "open" "<thing>"
    printf "%s6\n" "take" "<object>"
    printf "%s6\n" "use <object>\n"
    printf "%s6\n" "help"
    printf "%s6\n" "quit"
    printf "\n"
}

where ()
{
    cat *.txt
}

goto ()
{
    if [[ $1 = "living room" ]] || [[ $1 = "kitchen" ]]
    then
        printf "you leave the $room and walk into the %s\n\n" $1

        if [[ -n $have_keys ]]
        then
            game_over
        else
            where
        fi
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
while [ "$game" != "over" ]
do
    read user_input1 user_input2
    echo $user_input1 $user_input2
    case $user_input1 in
        where) where ;;
        goto) goto $user_input2 ;;
        open) open $user_input2 ;;
        take) take $user_input2 ;;
        use) use $user_input2 ;;
        help) help; cd ..; pwd ;;
        quit) quit; break ;;
        *) invalid_move
    esac
done

