/*--------------------------------------------------
*	Copyright		:	www.jj.cn 2019
*	Author			:	zhangws
*	Date				:	2019-11-16
*	Description	:	���ڹ���ͷ�ļ�
--------------------------------------------------*/
#ifndef __DATA_H__
#define __DATA_H__

#include<iostream>
#include<cmath>
using namespace std; 

class Date
{
public:
	Date();
	Date(int year, int month, int day);
	Date(const Date& date);
	~Date();
	void clear();
	bool valid();
	void adddays(int days = 1);
	void addmonths(int months = 1);
	void addyears(int years = 1);
	int getyear();
	int getmonth();
	int getday();
	int getdate(); // 20191106
	void input();
	void output();

private:
	bool leap(int years);																	//�ж�ָ��������Ƿ�Ϊ����
	int dton();																						//������ת��Ϊ��1��1��1���������
	void ntod(int days);																	//��ָ����1��1��1���������ת��Ϊ����

private:
	int _year;
	int _month;
	int _day;
};

#endif //__DATA_H__
