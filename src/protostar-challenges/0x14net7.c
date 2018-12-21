#include "../common/common.c"

#define NAME "net3"
#define UID 996
#define GID 996
#define PORT 2996

/*
   * Extract a null terminated string from the buffer 
  */

int get_string(char **result, unsigned char *buffer, u_int16_t len)
{
    unsigned char byte;

    byte = *buffer;

    if (byte > len)
        errx(1, "badly formed packet");
    *result = malloc(byte);
    strcpy(*result, buffer + 1);

    return byte + 1;
}

/*
  * Check to see if we can log into the host
  */

int login(unsigned char *buffer, u_int16_t len)
{
    char *resource, *username, *password;
    int deduct;
    int success;

    if (len < 3)
        errx(1, "invalid login packet length");

    resource = username = password = NULL;

    deduct = get_string(&resource, buffer, len);
    deduct += get_string(&username, buffer + deduct, len - deduct);
    deduct += get_string(&password, buffer + deduct, len - deduct);

    success = 0;
    success |= strcmp(resource, "net3");
    success |= strcmp(username, "awesomesauce");
    success |= strcmp(password, "password");

    free(resource);
    free(username);
    free(password);

    return !success;
}

void send_string(int fd, unsigned char byte, char *string)
{
    struct iovec v[3];
    u_int16_t len;
    int expected;

    len = ntohs(1 + strlen(string));

    v[0].iov_base = &len;
    v[0].iov_len = sizeof(len);

    v[1].iov_base = &byte;
    v[1].iov_len = 1;

    v[2].iov_base = string;
    v[2].iov_len = strlen(string);

    expected = sizeof(len) + 1 + strlen(string);

    if (writev(fd, v, 3) != expected)
        errx(1, "failed to write correct amount of bytes");
}

void run(int fd)
{
    u_int16_t len;
    unsigned char *buffer;
    int loggedin;

    while (1)
    {
        nread(fd, &len, sizeof(len));
        len = ntohs(len);
        buffer = malloc(len);

        if (!buffer)
            errx(1, "malloc failure for %d bytes", len);

        nread(fd, buffer, len);

        switch (buffer[0])
        {
        case 23:
            loggedin = login(buffer + 1, len - 1);
            send_string(fd, 33, loggedin ? "successful" : "failed");
            break;

        default:
            send_string(fd, 58, "what you talkin about willis?");
            break;
        }
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

    run(fd);
}