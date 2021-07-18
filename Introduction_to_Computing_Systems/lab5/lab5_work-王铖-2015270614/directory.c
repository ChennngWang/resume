#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


typedef struct directoryNode directory;

struct directoryNode{    //�洢���
    char name[21];
    char room[11];

    directory *next;
};

    directory head;
    directory *current;
    directory *previous;
    int m,n;
    char ch[21];    //��ʱ�洢�ַ���

void Input()         //����������������
{
    previous=&head;
    scanf("%d",&n);
    for(;n>0;n--)
    {
        current=(directory*)malloc(sizeof(directory));
        scanf("%s",current->name);
        scanf("%s",current->room);
        current->next=NULL;
        previous->next=current;
        previous=previous->next;
    }
}


bool Check(char *ch1,char *ch2)    //����ַ����Ƿ����
{
    bool flag=true;
    int i=0;
    while(((ch1[i])!='\0')&&((ch2[i])!='\0'))
    {
        if(ch1[i]==ch2[i])
            i++;
        else
        {
            flag=false;
            return flag;
        }
    }
    return flag;
}

void Search2()     //Search���Ӻ���
{
    previous=&head;
    current=head.next;
    scanf("%s",ch);
    while(current!=NULL)
    {
        if(Check(ch,current->room))
        {
            printf("%s\n",current->name);
            return;
        }
        previous=current;
        current=current->next;
    }
    printf("No Entry\n");
}



void Search()     //Ѱ�ҷ���ţ����ؽ������ֻ�No Entry
{
    scanf("%d",&m);
    for(;m>0;m--)
    {
        Search2();
    }
}


int main()
{

    freopen("directory.in","r",stdin);
    freopen("directory.out","w",stdout);

    head.next=NULL;
    Input();
    Search();
    return 0;
}
