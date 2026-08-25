namespace SharperMe.ConsoleApp.Tests;

public class ConsleAppTests
{
    [Fact]
    public void Test_ConsoleApp_ReturnTrue()
    {
        Assert.True(true);
    }

    [Fact]
    public void Test_Sum_ReturnTwo()
    {
        var result = Program.Sum(1, 1);
        Assert.Equal(2, result);
    }
}