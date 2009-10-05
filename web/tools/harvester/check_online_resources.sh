#! /bin/sh

python $(olacvar harvester/integrity) -u
for i in 9 8 7 6 5 4 3 2 1 0; do
    flock $(olacvar locks/metrics) python $(olacvar harvester/metrics)
    [ $? -eq 0 ] && break
    echo
    echo "Program crashed. Trying again in 10 minutes..."
    echo
    sleep 600
done

