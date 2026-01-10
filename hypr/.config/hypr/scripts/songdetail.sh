
#!/bin/bash

if playerctl -p spotify status &>/dev/null; then
    song_info=$(playerctl -p spotify metadata --format '  {{title}} - {{artist}}')
    echo "$song_info"
else
    echo "no media"
fi

