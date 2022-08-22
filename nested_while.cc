#define ROW_MAX 10
#define COL_MAX 10

int main()
{   
    int i = 0, accum = 0;
    while (i < ROW_MAX)
    {
        int j = 0;
        while (j < COL_MAX)
        {
            accum += i + j;
            j++;
        }
        i++;
    }
    return 0;
}