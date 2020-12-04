#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define foreach(item, array) \
    for(int keep = 1, \
            count = 0,\
            size = sizeof (array) / sizeof *(array); \
        keep && count != size; \
        keep = !keep, count++) \
      for(item = (array) + count; keep; keep = !keep)

char TREE = '#';

char *readFile(char *);
char **splitString(char *, char *);
int wasTreeHit(char *, int);
void printDayThreeOneAnswer(char **);
void printDayThreeTwoAnswer(char **);

int main() {
    char **map = splitString(readFile("input.txt"), "\r\n");

    printDayThreeOneAnswer(map);
    printDayThreeTwoAnswer(map);

    free(map);

    return EXIT_SUCCESS;
}

char *readFile(char *fileName) {
    char *contents;
    FILE *file = fopen(fileName, "r");
    if (file == NULL) {
        return "Failed";
    }

    fseek(file, 0L, SEEK_END);
    long length = ftell(file);
    rewind(file);

    contents = (char*)calloc(length, sizeof(char));
    if(contents == NULL)
        return "Failed";
    
    fread(contents, length, 1, file);

    fclose(file);
    return contents;
}

char **splitString(char *str, char *delimiter) {
    char ** res = NULL;
    char * p = strtok (str, delimiter);
    int length = 0;

    while (p != NULL) {
        res = realloc (res, sizeof (char*) * ++length);

        if (res == NULL) {
            exit (-1);
        }

        res[length-1] = p;

        p = strtok (NULL, delimiter);
    }

    // make one extra row with value of 'NULL'
    res = realloc (res, sizeof (char*) * (length+1));
    res[length] = 0;

    return res;
}

int wasTreeHit(char *coordinateRow, int index) {
    if (coordinateRow[index] == TREE) {
        return 1;
    }

    return 0;
}

void printDayThreeOneAnswer(char **map) {
    int trees = 0;
    int index = 0;
    char *coordinateRow;

    if ((coordinateRow = map[0]) == NULL) return;

    while (coordinateRow) {
        int length = strlen(coordinateRow);
        index = index >= length ? index % length : index;
        trees += wasTreeHit(coordinateRow, index);
        // printf("%d %s %c %d %d\n", length, coordinateRow, coordinateRow[index], index, trees);

        index += 3;
        coordinateRow = *++map;
    }

    printf("%d were hit\n", trees);
}

void printDayThreeTwoAnswer(char **map) {
    int slopes[] = { 1, 3, 5, 7, 1 };
    int skip[] = { 1, 1, 1, 1, 2 };
    int hitTrees[] = {0, 0, 0, 0, 0};

    for (int i = 0; i < sizeof(slopes)/sizeof(slopes[0]); i++) {
        int trees = 0;
        int index = 0;
        int row = 0;
        char *coordinateRow;
        char **newMap = map;

        if ((coordinateRow = newMap[0]) == NULL) return;

        while (coordinateRow) {
            if (row++ % skip[i] != 0) {
                // printf("Skipped %d %% %d = %d\n", row, skip[i], row % skip[i]);
                coordinateRow = *++newMap;
                continue;
            }

            int length = strlen(coordinateRow);
            index = index >= length ? index % length : index;
            trees += wasTreeHit(coordinateRow, index);
            // printf("%d %d %s %c %d %d\n", row - 1, length, coordinateRow, coordinateRow[index], index, trees);

            index += slopes[i];
            coordinateRow = *++newMap;
        }

        hitTrees[i] = trees;
    }

    long multiplied = 1;
    printf("{ ");
    foreach(int *trees, hitTrees) {
        multiplied = multiplied * *trees;
        printf("%d, ", *trees);
    }
    printf("}\n%lu\n", multiplied);
}