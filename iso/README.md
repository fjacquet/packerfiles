### Local ISO Cache

Place custom ISO images in this directory to use them instead of downloading from the internet.

This is useful for:
- MSDN / Volume License Windows ISOs
- Locally cached Linux distribution ISOs
- Custom or modified ISOs

#### Usage

Override the `iso_url` variable when building:

```bash
packer build \
    -var iso_url=./iso/my-custom.iso \
    -var 'iso_checksum=sha256:abc123...' \
    -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl \
    templates/ubuntu/
```

All `.iso` files in this directory are gitignored.
