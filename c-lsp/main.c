#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static void die(const char *msg) {
    perror(msg);
    exit(1);
}

int main(int argc, char **argv) {
    const char *server = getenv("KAUDO_C_LSP");
    if (!server || !*server) server = "clangd";

    // Build argv for exec: server + passthrough args, defaulting to --log=error when none
    char **args = malloc(sizeof(char*) * (argc + 2));
    if (!args) die("malloc");
    int idx = 0;
    args[idx++] = (char*)server;
    if (argc > 1) {
        for (int i = 1; i < argc; ++i) args[idx++] = argv[i];
    } else {
        args[idx++] = "--log=error";
    }
    args[idx] = NULL;

    pid_t pid = fork();
    if (pid < 0) die("fork");

    if (pid == 0) {
        // child: exec server
        execvp(server, args);
        die("execvp clangd");
    }

    free(args);

    int status = 0;
    if (waitpid(pid, &status, 0) < 0) die("waitpid");

    if (WIFEXITED(status)) {
        int code = WEXITSTATUS(status);
        if (code != 0) {
            fprintf(stderr, "%s exited with code %d\n", server, code);
            return code;
        }
        return 0;
    } else if (WIFSIGNALED(status)) {
        fprintf(stderr, "%s terminated by signal %d\n", server, WTERMSIG(status));
        return 1;
    }

    return 1;
}
