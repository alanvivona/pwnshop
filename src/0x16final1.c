#include "../common/common.c"

#include <syslog.h>

#define NAME "final1"
#define UID 0
#define GID 0
#define PORT 2994

char username[128];
char hostname[64];

void logit(char *pw)
{
    char buf[512];

    snprintf(buf, sizeof(buf), "Login from %s as [%s] with password [%s]\n", hostname, username, pw);

    syslog(LOG_USER | LOG_DEBUG, buf);
}

void trim(char *str)
{
    char *q;

    q = strchr(str, '\r');
    if (q)
        *q = 0;
    q = strchr(str, '\n');
    if (q)
        *q = 0;
}

void parser()
{
    char line[128];

    printf("[final1] $ ");

    while (fgets(line, sizeof(line) - 1, stdin))
    {
        trim(line);
        if (strncmp(line, "username ", 9) == 0)
        {
            strcpy(username, line + 9);
        }
        else if (strncmp(line, "login ", 6) == 0)
        {
            if (username[0] == 0)
            {
                printf("invalid protocol\n");
            }
            else
            {
                logit(line + 6);
                printf("login failed\n");
            }
        }
        printf("[final1] $ ");
    }
}

void getipport()
{
    int l;
    struct sockaddr_in sin;

    l = sizeof(struct sockaddr_in);
    if (getpeername(0, &sin, &l) == -1)
    {
        err(1, "you don't exist");
    }

    sprintf(hostname, "%s:%d", inet_ntoa(sin.sin_addr), ntohs(sin.sin_port));
}

int main(int argc, char **argv, char **envp)
{
    int fd;
    char *username;

    /* Run the process as a daemon */
    background_process(NAME, UID, GID);

    /* Wait for socket activity and return */
    fd = serve_forever(PORT);

    /* Set the client socket to STDIN, STDOUT, and STDERR */
    set_io(fd);

    getipport();
    parser();
}