{
    description = "This is a workspace for shader development";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
        glslViewer.url = "./nix/pkgs/glslViewer";
    };
  
    outputs = { self, nixpkgs, flake-utils, glslViewer }: 
        flake-utils.lib.eachDefaultSystem (system:
        let 
            pkgs = import nixpkgs { inherit system; };
        in rec {
            devShells.default = pkgs.mkShell {
                packages = [ glslViewer.defaultPackage.${system} ];

                shellHook = ''
                    echo
                    echo "     [[[[[  Welcome to the Nebula  ]]]]]"
                    echo "     ᚤᛟᚢ ᚨᚱᛖ ᛒᛖᚲᛟᛗᛁᚾᚷ ᛟᚾᛖ ᚹᛁᛏᚺ ᛏᚺᛖ ᛋᛏᚨᚱᛋ"
                    echo "     [[[[[  •+-#—*#•SHADER*+-+••## ]]]]]"
                    echo
                '';
            };
        }
    );
}