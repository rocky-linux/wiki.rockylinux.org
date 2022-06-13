---
title: Signing Commits with GPG
author: Al Bowles
revision_date: 2022-06-13
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---
# Creating your primary keypair
Initiate the keypair generation wizard

    gpg --full-generate-key --expert

Select option `(9) ECC and ECC` for the key type
Select option `(1) Curve 25519` for the elliptic curve
Set a validity period of your choice, ideally less than 1 year
Specify real name and email address to associate with this keypair
Type a passphrase (twice)

# Create a signing keypair
Add a signing subkey

    gpg --edit-key my@email.addr
    gpg> addkey
    [ passphrase ]

Select [ECC] (sign / authenticate / encrypt?) for kind of key, 4096 bits, valid for 180d

    gpg> save

Create revocation certificate

    gpg --output \<my@email.addr\>.gpg-revocation-certificate --gen-revoke my@email.addr

# Back up your keypair
Export the *primary keypair* (put these somewhere very safe along with revocation certificate)

    gpg --export-secret-keys --armor my@email.addr > \<my@email.addr\>.private.gpg-key
    gpg --export --armor my@email.addr > \<my@email.addr\>.public.gpg-key

# Remove the *primary keypair* from your keyring
Export all subkeys from the new keypair to a file - use ramfs instead of tmpfs/ or /dev/shm/ because ramfs doesn't write to swap

    mkdir /tmp/gpg
    sudo mount -t ramfs -o size=1M ramfs /tmp/gpg
    sudo chown $(logname):$(logname) /tmp/gpg
    gpg --export-secret-subkeys my@email.addr > /tmp/gpg/subkeys

Delete original signing subkey from keypair in our keyring

    gpg --delete-secret-key my@email.addr

Re-import the previously exported keys

    gpg --import /tmp/gpg/subkeys
    sudo umount /tmp/gpg
    rmdir /tmp/gpg

Look for `sec#` instead of `sec` in the output - pound sign means signing subkey is *not* in the keypair located in the keyring
    gpg --list-secret-keys $HOME/.gnupg/secring.gpg

# Revoking a *signing keypair*
Find the *primary keypair* and import it (preferably into an ephemeral system like a liveUSB)

    gpg --import /path/to/\<my@email.addr\>.public.gpg-key /path/to/\<my@email.addr\>.private.gpg-key
    gpg --edit-key my@email.addr
    gpg> revkey
    [ passphrase twice ]
    gpg> save


# Renew an expired or expiring keypair

    gpg --edit-key my@email.addr
    [select a key]
    gpg> expire
    [specify an expiration]
    gpg> save

# Create a single signed git commit

    git commit -S -m "my awesome signed commit"

# Configure git to always sign commits with a specified key

    $ gpg --list-secret-keys --keyid-format=long # grab the fingerprint from the 'sec' line
    git config [--global] commit.gpgsign true
    git config [--global] user.signingkey DEADB33FBAD1D3A

# Configure VSCode to sign commits

    # User or workspace setting
    "git.enableCommitSigning": true

# References
[OpenPGP Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices#key-configuration)<br>
[Github: Signing Commits](https://docs.github.com/en/enterprise-server@3.5/authentication/managing-commit-signature-verification/signing-commits)<br>
[Braincoke's Log: Create a GPG Key](https://blog.braincoke.fr/security/create-a-gpg-key/)<br>
[Creating the Perfect GPG Keypair](https://alexcabal.com/creating-the-perfect-gpg-keypair)<br>
[Digital Neanderthal: Generate GPG Keys With Curve Ed25519](https://www.digitalneanderthal.com/post/gpg/)<br>
