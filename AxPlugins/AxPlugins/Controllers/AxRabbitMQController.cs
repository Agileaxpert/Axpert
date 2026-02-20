using Microsoft.AspNetCore.Mvc;
using AxExtend.Interface;

namespace AxPlugins
{
    [ApiController]
    [Route("[controller]")]
    public class AxRabbitMQController : ControllerBase
    {

        private readonly ILogger<AxRabbitMQController> _logger;

        private readonly IAxExtend _axExtend;

        public AxRabbitMQController(ILogger<AxRabbitMQController> logger, IAxExtend axExtend)
        {
            _logger = logger;
            _axExtend = axExtend;
        }

        [HttpGet("AxRabbitMQTest")]
        public string AxDBTest()
        {
            return "AxRabbitMQ Test Success";
        }

        [HttpPost("PushToQueue")]
        public async Task<IActionResult> PushToQueue(AxRabbitMQ rmqInput)
        {

            try
            {

                var rmq = await _axExtend.GetRabbitMQProducer();
                if (rmq != null)
                {
                    var rmqResult = rmq.SendMessages(rmqInput.QueueData, rmqInput.QueueName, false, 0, 0);
                    if (rmqResult)
                        return Ok("Pushed to Queue");
                    else
                        return Ok("Pushing data to Queue failed");
                }
                else
                {
                    return BadRequest("Unable to connect to RabbitMQ.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }
            finally
            {
            }

        }


    }
}