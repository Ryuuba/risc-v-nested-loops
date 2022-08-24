int main()
{   
    int accum = 0;
    int row_max = 16, col_max = 16;
    for (int i = 0; i < row_max; i++)
        for(int j = 0; (i < row_max/4 || i >= 3*row_max/4) && j < col_max; j++)
            accum += i + j;
    return 0;
}