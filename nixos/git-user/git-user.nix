{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  which,
}:

buildGoModule rec {
  pname = "git-user";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "gesquive";
    repo = "git-user";
    rev = "v${version}";
    hash = "sha256-DWimQV+IRP5F6wUp601muzuljcDGeuQTnU8gEB+acqM=";
  };

  vendorHash = "sha256-NLmcWFEAsUUieMXX2NCyQGIQsLQ0L7je17oUAzUllaA=";

  # This is responsible for generating the shell completions.
  # However, these completions are very bad and not really usefull.
  # They also don't seem to be officially supported.
  # As such, they are disabled.
  # nativeBuildInputs = [ git which installShellFiles ];
  #
  # postInstall = ''
  #   installShellCompletion --cmd git-user \
  #     --zsh <($out/bin/git-user completion zsh)
  # '';
}
