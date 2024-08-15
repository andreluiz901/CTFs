# CTFs
scripts and tools devloped to ctf and challenges


## Scripts

### Hack in Cariri

#### Token Tinker

- Scripts to find username (python and bash):

    - do not forget to use `chmod +x` to give permission to run before launch scripts

    - captcha_authenticate.py requires:
        - requests: `pip3 install requests`

    - captcha_authenticate.sh requires: 
        - jq: 
            - Ubuntu/Debian:
                - `sudo apt-get update`
                - `sudo apt-get install jq`
            - CentOS/Fedora/RHEL:
                - `sudo yum install jq`
            - macOS (Homebrew):
                - `brew install jq`
            - Windows:
                - use WSL or git Bash. Or download binary at official JQ site and add to PATH (to much work, dont recommend) 
 
    - **USAGE**: just give any wordlist --> `python3 captcha_authenticate.py usernames.txt`

    - *If you want a more fast use of python*, remove the sleep time, its just for correct printing. It becomes so fast that some printing become not easy to read. 

- scripts to find password:

    - **IMPORTANT**: you need to insert the username inside the script after you find with the username script, where indicated by `INSERT_HERE_AFTER_FIND`

    - captcha_password.py and captcha_password.sh

    - Usage and requirements same as last section.
