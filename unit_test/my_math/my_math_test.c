#include "unity_fixture.h"

#include "my_math.h"

TEST_GROUP(my_math);

TEST_SETUP(my_math)
{
    
}

TEST_TEAR_DOWN(my_math)
{

}

TEST(my_math, add)
{
    int a = 100;
    int b = -200;
    TEST_ASSERT_EQUAL(-100, add(a, b));
    TEST_ASSERT_EQUAL_MESSAGE(21, add(10, 12), "Test funkcji dodawania");

    // TEST_FAIL_MESSAGE("Message test");
}

TEST(my_math, sub)
{
    int a = 100;
    int b = -200;
    int result = sub(a, b);

    TEST_ASSERT_EQUAL(300, result);
    TEST_ASSERT_EQUAL(200, result);

    TEST_FAIL_MESSAGE("Message test");
}