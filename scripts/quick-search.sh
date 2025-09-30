#!/usr/bin/env bash
# Quick search using local SearXNG instance
# Opens Firefox with search query in SearXNG

query=$(zenity --entry --title="Quick Search" --text="Enter search query:" 2>/dev/null)

if [ -n "$query" ]; then
    encoded=$(echo "$query" | jq -sRr @uri)
    firefox "http://localhost:3001/search?q=$encoded" &
fi
