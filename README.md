# Homeserver

## Base info
Running on a Raspberry Pi 4 model b

## Flashing with dd

`sudo dd if=result/sd-image/...img of=/dev/sdc bs=4096 conv=fsync status=progress`

- `bs` block sice
- `conv=fsync` How it's writen, don't use cache with fsync
- `status=progress` show the status on the console
- `of` output file (or device)
- `if` input file
