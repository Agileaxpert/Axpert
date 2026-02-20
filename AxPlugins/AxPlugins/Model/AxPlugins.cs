namespace AxPlugins
{
    public class AxRedis
    {
        public string ARMSessionId { get; set; } = string.Empty;
        public string AppName { get; set; } = string.Empty;
        public string Key { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
        public int ExpiryInSeconds { get; set; } = 0;
    }

    public class AxDB
    {
        public string AppName { get; set; } = string.Empty;
        public string SQL { get; set; } = string.Empty;
    }

    public class AxRabbitMQ
    {
        public string QueueName { get; set; } = string.Empty;
        public string QueueData { get; set; } = string.Empty;
    }
}
