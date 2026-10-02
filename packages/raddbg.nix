{ pkgs }:

pkgs.clangStdenv.mkDerivation {
  pname = "raddebugger";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    rev = "bf000289db62a8c82038ce9e34debc75ce7e2f93";
    hash = "sha256-qP96Qx+a1fOf/X0Cjd5uj7B+elAp4hCECd00NO8Kp1Y=";
  };

  nativeBuildInputs = with pkgs; [
    llvm
    pkg-config
    git
  ];

  buildInputs = with pkgs; [
    freetype
    libx11
    libxext
    libxfixes
    libxrandr
    libGL
    libglvnd
  ];

  postPatch = ''
	patchShebangs build.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh radlink release
    ./build.sh radbin release
    ./build.sh raddbg release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp build/radlink $out/bin/
    cp build/radbin  $out/bin/
    cp build/raddbg  $out/bin/

    runHook postInstall
  '';
}


