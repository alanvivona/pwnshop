#include "../common/common.c"

#define NAME "net2"
#define UID 997
#define GID 997
#define PORT 2997

void run()
{
    unsigned int quad[4];
    int i;
    unsigned int result, wanted;

    result = 0;
    for (i = 0; i < 4; i++)
    {
        quad[i] = random();
        result += quad[i];

        if (write(0, &(quad[i]), sizeof(result)) != sizeof(result))
        {
            errx(1, ":(\n");
        }
    }

    if (read(0, &wanted, sizeof(result)) != sizeof(result))
    {
        errx(1, ":<\n");
    }

    if (result == wanted)
    {
        printf("you added them correctly\n");
    }
    else
    {
        printf("sorry, try again. invalid\n");
    }
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

    /* Don't do this :> */
    srandom(time(NULL));

    run();
}