# On library attachment, print message to user.
.onAttach <- function(libname, pkgname) {

    msg <- paste0(
        "Welcome to healthyR.data! -------------------------------------------",
        "\nIf you find this package useful, please leave a star: https://github.com/spsanderson/healthyR.data'",
        "\nIf you encounter a bug or want to request an enhancement please file an issue at:",
        "\n   https://github.com/spsanderson/healthyR.data/issues",
        "\nThank you for using healthyR.data!"
    )

    packageStartupMessage(msg)

}
