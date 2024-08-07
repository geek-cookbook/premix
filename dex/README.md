# Dex basics

1. Create /var/data/dex/config/
2. Copy config.yml.example to /var/data/dex/config/config.yml
3. Create /var/data/dex/db, and chmod to whichever user dex runs as (or 777 if you're lazy and you want to find out)
4. Deploy the stack (`docker stack deploy dex -c /var/data/config/dex/dex.yml`)
