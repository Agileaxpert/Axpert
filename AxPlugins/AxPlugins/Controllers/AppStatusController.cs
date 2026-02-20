using Microsoft.AspNetCore.Mvc;

namespace AxPlugins
{
    [Route("api/v1")]
    [ApiController]
    public class AppStatusController : ControllerBase
    { 
        [HttpGet("AppStatus")]
        public ActionResult ARMAppStatus()
        {
            return Ok("Application is running successfully.");
        }
    }
}