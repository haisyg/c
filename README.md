# include<stdio.h>
int main(){
int time=0;
printf("join university\n");
while(time<5)
{printf("every day the time of learn:%d\n",time);
time++;}
if(time>=5)
printf("have a good job");
return 0;
}
#include<stdio.h>
int main()
{int input=0;
printf("join university\n");
printf("well you study hard?(1 or 0)");
scanf("%d",&input);
if(input==1)
printf("have a good future");
else printf("poor\n");
return 0;}
int main()
{
	int a = 3;
	if (1 == a % 2)
	{
		printf("%d\n", a);
	}
	else printf("no\n");
	return 0;
}
int main()
{
	int a = 0;
	while (a < 101)
	{
		if (1 == a % 2)
			printf("%d\n", a);
		a++;
	}
	return 0;
}
int main()
{
	int day = 0;
	scanf("%d",& day);
	switch(day)
	{
	case 1:printf("ok\n"); break;
	default:printf("no\n");
	}
	system("pause");
	return 0;
}
int main()
{
	int n = 0;
	int ret = 1;
	int sum = 0;
	for(n=1;n<=3;n++)
	{   ret *= n;
		sum += ret;
	}
	printf("%d\n", sum);
    system("pause");
	return 0;
}
nt main()
{
	int a = 0;
	int ch;
	char password[20] = { 0 };
	printf("请输入密码\n");
	scanf("%s", password);
    while ((ch = getchar() )!= '\n')
	{
		;
	}
	printf("请确认\n(y or n)");
	a = getchar();
		if (a == 'y')
		{
			printf("确认成功\n");
		}
	else
		printf("取消确认\n");
	system("pause");
		return 0;
}
#include<stdio.h>
#include<string.h>
int main()
{   int arr[] = { 1,2,3,4,5,6,7,8,9,10 };
	int left = 0;
	int sz = sizeof(arr) / sizeof(arr[0]);
	int right = sz - 1;
	int a = 9;
	for(;left<=right;)
	{int mid = (left + right) / 2;
		if (arr[mid]>a)
		{
			right = mid - 1;
		}
		else if (arr[mid] < a)
		{
			left = mid + 1;
		}
		else
		{
			printf("找到了，下标为%d\n ", mid);
			break;
		};
	}
	system("pause");
		return 0;
}
