_default:
    just --list

check:
    nix flake check

package profile='x86_64-linux':
    nix build \
        --json \
        --no-link \
        --print-build-logs \
        '.#{{ profile }}'

update:
    nix flake update
