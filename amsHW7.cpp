// AMS 595 Homework Assignment 7
// Ramona Tobey
// id: 117607747

#include <stdio.h>
#include <iostream>
#include <string>
#include <vector>
#include <cmath>
using namespace std;

// function declarations:
bool isprime(int n);

void print_vector(vector<int> v);

void test_isprime();

vector<int> factorize(int n);

void test_factorize();

vector<int> prime_factorize(int n);

void test_prime_factorize();

vector<int> pascal(int n);

int main()
{
    // part one: write the following matlab code in c++
    //  n = input(’Enter a number: ’);
    //  switch n
    //  case -1
    //  disp(’negative one’)
    //  case 0
    //  disp(’zero’)
    //  case 1
    //  disp(’positive one’)
    //  otherwise
    //  disp(’other value’)
    //  end
    int num;
    // asking for input
    cout << "Enter a number: ";
    cin >> num;
    // identifying input
    switch (num)
    {
    case -1:
        printf("negative one");
        break;
    case 0:
        printf("zero");
        break;
    case 1:
        printf("positive one");
        break;
    default:
        printf("other value");
    }

    // part three: while loop for fibonaci
    int a, b, fib_numb;
    a = 1;
    b = 2;
    fib_numb = 0;
    cout << "\nFibonacci sequence: \n";
    while (a + b < 40000000)
    {
        fib_numb = a + b;
        a = b;
        b = fib_numb;
        cout << fib_numb << "\n";
    }

    // Testing is prime part 4:

    printf("\n prime tests:\n");
    test_isprime();

    // factorization test

    printf("\n factors tests:\n");
    test_factorize();

    // prime factors test:

    printf("\n prime factors tests:\n");
    test_prime_factorize();

    // part five, testing for pascal

    printf("\n test for sixth row of pascal:\n");
    print_vector(pascal(6));
}

//***END OF MAIN***

// funtion definitions:

// part two: making a vector print function

void print_vector(vector<int> v)
{
    for (int element : v)
    {
        cout << element << "\n";
    }
}

// part four:
bool isprime(int n)
{
    bool result;
    int i;
    // first two special cases
    switch (n)
    {
    case 1:
        result = 0;
        break;
    case 2:
        result = 1;
        break;
    // all other cases
    default:
        for (i = 2; i < n; i++)
        {
            if ((n % i) == 0)
            {
                result = 0;
                break;
            }
            if (i > sqrt(n))
            {
                result = 1;
                break;
            }
        }
    }
    return result;
}

// test function:

void test_isprime()
{
    std::cout << "isprime(2) = " << isprime(2) << "\n";
    std::cout << "isprime(10) = " << isprime(10) << "\n";
    std::cout << "isprime(17) = " << isprime(17) << "\n";
}

// factorization function
vector<int> factorize(int n)
{
    vector<int> answer;
    int i;
    for (i = 2; i < sqrt(n) + 1; i++)
    {
        if ((n % i) == 0)
        {
            answer.push_back(i);
        }
    }
    return answer;
}

// test for factors:
void test_factorize()
{
    print_vector(factorize(2));
    print_vector(factorize(72));
    print_vector(factorize(196));
}

// prime factorization function:

vector<int> prime_factorize(int n)
{
    vector<int> answer;
    vector<int> allFactors;
    allFactors = factorize(n);
    for (int element : allFactors)
    {
        if (isprime(element))
        {
            answer.push_back(element);
        }
    }
    return answer;
}

// test cases for prime factors:
void test_prime_factorize()
{
    print_vector(prime_factorize(2));
    print_vector(prime_factorize(72));
    print_vector(prime_factorize(196));
}

// part five:
vector<int> pascal(int n)
{
    vector<int> pascalRowNMinusOne, pascalRowN;
    int i;
    if (n == 1)
    {
        pascalRowN.push_back(1);
    }
    else
    {
        pascalRowNMinusOne = pascal(n - 1);
        pascalRowN = {1};
        for (i = 1; i < n - 1; i++)
        {
            pascalRowN.push_back(pascalRowNMinusOne[i] + pascalRowNMinusOne[i - 1]);
        }
        pascalRowN.push_back(1);
    }
    return pascalRowN;
}
