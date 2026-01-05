{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "git-anonymizer-shell";

  buildInputs = [
    pkgs.git
    pkgs.python3
    pkgs.git-filter-repo
  ];

  shellHook = ''
    echo "[INFO] Entered git anonymization shell"

    # Prevent Git from using global/system config
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null

    # Disable any signing or GPG usage
    export GIT_COMMITTER_NAME="Anonymous"
    export GIT_COMMITTER_EMAIL="anon@example.com"
    export GIT_AUTHOR_NAME="Anonymous"
    export GIT_AUTHOR_EMAIL="anon@example.com"
    export GIT_GPG_SIGN=0
    export GIT_TRACE_GPG=0

    # Make sure no GPG agent or SSH agent leaks identity
    unset GPG_AGENT_INFO
    unset SSH_AUTH_SOCK

    echo "[INFO] Global git config and signing disabled"
  '';
}
