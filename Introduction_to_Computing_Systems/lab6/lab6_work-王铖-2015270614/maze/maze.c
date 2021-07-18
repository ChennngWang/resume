#include <stdio.h>
#include <stdlib.h>

char maze[100][16];      //���ַ�����ʽ����Թ�����
int i,j;         //��ʼλ��
int stack[50];    //��ַջ
int stackcounter=0;     //��ַջ������
int address;

void Output()     //����ַջ�е����ݴ�������
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


void Input()         //���Թ����ݴ�������maze
{
    int a=0;
    for(;a<=50;a++)
        scanf("%s",maze[a]);
}

void Start()    //������ʼ��ַi��j
{
    i=(maze[1][15]-'0')+2*(maze[1][14]-'0')+4*(maze[1][13]-'0');
    j=(maze[2][15]-'0')+2*(maze[2][14]-'0')+4*(maze[2][13]-'0')+8*(maze[2][12]-'0') ;
}

void Maze(int address)      //�ݹ�̽���Թ�
{
    maze[address][1]=1;    //����
    stack[stackcounter]=address;    //ѹջ
    stackcounter++;           //ջ��������һ
    if(maze[address][11]=='1')   //��⵽���ڣ���ջ���
        Output();
    if(maze[address][15]=='1')    //�����Ƿ���·
    {
        address--;
        if(maze[address][1]=='0')   //�Ƿ���
        {
            Maze(address);//west    //��·���б�ǣ��ݹ�̽��
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
    if(stackcounter==0)    //��ַջ�գ����No path
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
