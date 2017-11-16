#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cs50.h>

typedef struct
{
    char *name;
    char *dorm;
}
student;

int cmp(const void *a, const void *b);

int main(void)
{
    student heads[] =
    {
        {"Stelios", "Branford"},
        {"Maria", "Cabot"},
        {"Anushree", "Ezra Stiles"},
        {"Brian", "Winthrop"}
    };
    printf("Before:\n");
    for (int i = 0; i < 4; i++)
    {
        printf("%s from %s\n", heads[i].name, heads[i].dorm);
    }
    qsort(heads, 4, sizeof(student), cmp);
    printf("After:\n");
    for (int i = 0; i < 4; i++)
    {
        printf("%s from %s\n", heads[i].name, heads[i].dorm);
    }
}

int cmp(const void *a, const void *b)
{
    const char* s1 = *(const char**)a;
    const char* s2 = *(const char**)b;

    return strcmp(s1, s2);
}
