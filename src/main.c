#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int firstconst(char *str); // function body is implemented in firstconst.s

int main(int argc, char const *argv[])
{
    if (argc < 2)
    {
        printf("Program requires a string as an argument\n");
        return -1;
    }
    
    char *input = strdup(argv[1]);
    printf("%d", firstconst(input));
    free(input);

    return 0;
}
