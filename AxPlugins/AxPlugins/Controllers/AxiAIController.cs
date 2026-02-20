using Microsoft.AspNetCore.Mvc;

namespace AxPlugins
{
    [ApiController]
    [Route("[controller]")]
    public class AxiAIController : Controller
    {
        private readonly OpenAIService _openAI;

        public AxiAIController(OpenAIService openAI)
        {
            _openAI = openAI;
        }

        [HttpPost("ask")]
        public async Task<IActionResult> Ask([FromBody] ChatRequest request)
        {
            var result = await _openAI.AskChatGPT(request.Prompt);
            return Ok(new { reply = result });
        }
    }


    public class ChatRequest
    {
        public string Prompt { get; set; }
    }
}
