#include "../common/common.c"
#include "../common/malloc.c"

#define NAME "final2"
#define UID 0
#define GID 0
#define PORT 2993

#define REQSZ 128

void check_path(char *buf)
{
    char *start;
    char *p;
    int l;

    /*
   * Work out old software bug
   */

    p = rindex(buf, '/');
    l = strlen(p);
    if (p)
    {
        start = strstr(buf, "ROOT");
        if (start)
        {
            while (*start != '/')
                start--;
            memmove(start, p, l);
            printf("moving from %p to %p (exploit: %s / %d)\n", p, start, start < buf ? "yes" : "no", start - buf);
        }
    }
}

int get_requests(int fd)
{
    char *buf;
    char *destroylist[256];
    int dll;
    int i;

    dll = 0;
    while (1)
    {
        if (dll >= 255)
            break;

        buf = calloc(REQSZ, 1);
        if (read(fd, buf, REQSZ) != REQSZ)
            break;

        if (strncmp(buf, "FSRD", 4) != 0)
            break;

        check_path(buf + 4);

        dll++;
    }

    for (i = 0; i < dll; i++)
    {
        write(fd, "Process OK\n", strlen("Process OK\n"));
        free(destroylist[i]);
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

    get_requests(fd);
}