{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  jq,
  ripgrep,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ticket";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "wedow";
    repo = "ticket";
    rev = "v${finalAttrs.version}";
    hash = "sha256-orxqAwJBL+LHe+I9M+djYGa/yfvH67HdR/VVy8fdg90=";
  };

  dontBuild = true;
  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 ticket $out/libexec/tk
    makeWrapper $out/libexec/tk $out/bin/tk --suffix PATH : ${lib.makeBinPath [jq ripgrep]}
  '';

  meta = {
    description = "Git-backed issue tracker for AI agents";
    homepage = "https://github.com/wedow/ticket";
    license = lib.licenses.mit;
    mainProgram = "tk";
  };
})
