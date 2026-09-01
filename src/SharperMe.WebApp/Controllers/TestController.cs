using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SharperMe.WebApp.Controllers
{
    [ApiController]
    [Route("/api/[controller]")]
    public sealed class TestController : ControllerBase
    {
        [HttpGet("tests")]
        public async Task<ActionResult<List<string>>> GetTests()
        {
            var list = await Task.FromResult(new List<string>()
            {
                "Test_1",
                "Test_2",
                "Test_3"
            });


            return this.Ok(list);
        }
    }
}