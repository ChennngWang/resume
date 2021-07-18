#include <stdio.h>
#include <stdlib.h>

char maze[100][16];      //以字符串形式存放迷宫数据
int i,j;         //初始位置
int stack[50];    //地址栈
int stackcounter=0;     //地址栈计数器
int address;

void Output()     //将地址栈中的内容处理后输出
{
    int b;
    stackcounter--;
    for(b=0;b<=stackcounter;b++)
    {
        i=-1;
        j=0;
        stack[b]-=3;
        do
        {
            stack[b]-=8;
            i++;
        }while(stack[b]>=0);
        if(i==-1) i=0;
        j=stack[b]+8;
        printf("%d%d ",i,j);
    }
    exit(0);
}


void Input()         //将迷宫数据存入数组maze
{
    int a=0;
    for(;a<=50;a++)
        scanf("%s",maze[a]);
}

void Start()    //计算起始地址i，j
{
    i=(maze[1][15]-'0')+2*(maze[1][14]-'0')+4*(maze[1][13]-'0');
    j=(maze[2][15]-'0')+2*(maze[2][14]-'0')+4*(maze[2][13]-'0')+8*(maze[2][12]-'0') ;
}

void Maze(int address)      //递归探测迷宫
{
    maze[address][1]=1;    //打标记
    stack[stackcounter]=address;    //压栈
    stackcounter++;           //栈计数器增一
    if(maze[address][11]=='1')   //检测到出口，弹栈输出
        Output();
    if(maze[address][15]=='1')    //西边是否有路
    {
        address--;
        if(maze[address][1]=='0')   //是否标记
        {
            Maze(address);//west    //有路，有标记，递归探测
        }
        address++;
    }
    if(maze[address][14]=='1')
    {
        address+=8;
        if(maze[address][1]=='0')
        {
            Maze(address);  //south
        }
        address-=8;
    }
    if(maze[address][13]=='1')
    {
        address++;
        if(maze[address][1]=='0')
        {
            Maze(address);  //east
        }
        address--;
    }
    if(maze[address][12]=='1')
    {
        address-=8;
        if(maze[address][1]=='0')
        {
            Maze(address);  //north
        }
        address+=8;
    }
    stackcounter--;
    if(stackcounter==0)    //地址栈空，输出No path
    {
        printf("No path");
        exit(0);
    }
}


int main()
{
    freopen("maze.in","r",stdin);
    freopen("maze.out","w",stdout);

    Input();
    Start();
    address=i*8+j+3;
    Maze(address);
}
