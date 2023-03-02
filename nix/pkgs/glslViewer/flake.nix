{
    description = "glslViewer";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
        glslViewer = {
            type = "git";
            url = "https://github.com/patriciogonzalezvivo/glslViewer?rev=2671e0f0b362bfd94ea5160f2ecb7f7363d4991d";
            flake = false;
            submodules = true; # needs type git to be set :/ (im pretty sure its an oversight / bug)
        };
    };

    outputs = {self, nixpkgs, flake-utils, glslViewer}:
        let
        in
        flake-utils.lib.eachDefaultSystem (system:
            let
                pkgs = import nixpkgs { inherit system; };
                frameworks = pkgs.darwin.apple_sdk.frameworks;
            in rec {
                defaultPackage = with pkgs; stdenv.mkDerivation rec {
                    name = "glslviewer";
                    version = "3.1.1";

                    src = glslViewer;

                    # NIX_LDFLAGS = "-F${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks";

                    postUnpack = ''
                        # echo Hello!
                        # echo $src
                        # echo Hello!
                        # cd $src
                        # echo | ls -al
                        # echo DIRECAFOKJS
                        # git submodule init
                        # git submodule update
                        # cd ..
                    '';

                    cmakeFlags = []
                    ++ lib.optionals (!stdenv.isDarwin) [
                    "-DCMAKE_C_FLAGS=-D_GLFW_GLX_LIBRARY='\"${lib.getLib libGL}/lib/libGL.so.1\"'"];
                    # makeFlags = lib.optional stdenv.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/libfoo.dylib";

                    nativeBuildInputs = [
                        git
                        pkg-config
                        cmake
                        ncurses
                        zlib
                    ]
                    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

                    buildInputs = [
                    ]
                    ++ lib.optionals stdenv.isDarwin [ frameworks.Cocoa frameworks.Kernel frameworks.VideoToolbox ];

                    propagatedBuildInputs = [ libGL ffmpeg ];

                    preInstall = ''
                        mkdir -p $out/bin        
                    '';

                    doCheck = false;
                };
            }
        );
}