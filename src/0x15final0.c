#include "../common/common.c"

#define NAME "final0"
#define UID 0
#define GID 0
#define PORT 2995

/*
  * Read the username in from the network
 */

char *get_username()
{
    char buffer[512];
    char *q;
    int i;

    memset(buffer, 0, sizeof(buffer));
    gets(buffer);

    /* Strip off trailing new line characters */
    q = strchr(buffer, '\n');
    if (q)
        *q = 0;
    q = strchr(buffer, '\r');
    if (q)
        *q = 0;

    /* Convert to lower case */
    for (i = 0; i < strlen(buffer); i++)
    {
        buffer[i] = toupper(buffer[i]);
    }

    /* Duplicate the string and return it */
    return strdup(buffer);
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

    username = get_username();

    printf("No such user %s\n", username);
}